import 'package:barnasht_app/core/errors/failures.dart';
import 'package:barnasht_app/core/services/database_service.dart';
import 'package:barnasht_app/core/services/firebase_auth_service.dart';
import 'package:barnasht_app/core/utils/back_end_point.dart';
import 'package:barnasht_app/features/places/data/models/place_model.dart';
import 'package:barnasht_app/features/places/domain/entities/place_entity.dart';
import 'package:barnasht_app/features/places/domain/repos/place_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

class PlaceRepoImpl extends PlaceRepo {
  final DatabaseService databaseService;
  final FirebaseAuthService firebaseAuthService;

  PlaceRepoImpl(this.databaseService, this.firebaseAuthService);

  // ============================================================
  // CACHE
  // ============================================================

  /// الأماكن المحملة لكل Category.
  ///
  /// key   = categoryId
  /// value = places
  final Map<String, List<PlaceEntity>> _placesCache = {};

  /// Requests الموجودة حاليًا.
  ///
  /// تمنع إرسال أكثر من request لنفس الـ category
  /// لو حصل أكثر من استدعاء في نفس الوقت.
  final Map<String, Future<Either<Failure, List<PlaceEntity>>>>
  _pendingRequests = {};

  // ============================================================
  // GET PLACES
  // ============================================================

  @override
  Future<Either<Failure, List<PlaceEntity>>> getPlaces({
    required String categoryId,
  }) async {
    // ------------------------------------------------------------
    // 1. Check Cache
    // ------------------------------------------------------------

    final cachedPlaces = _placesCache[categoryId];

    if (cachedPlaces != null) {
      return right(List<PlaceEntity>.from(cachedPlaces));
    }

    // ------------------------------------------------------------
    // 2. Check if request is already running
    // ------------------------------------------------------------

    final pendingRequest = _pendingRequests[categoryId];

    if (pendingRequest != null) {
      return pendingRequest;
    }

    // ------------------------------------------------------------
    // 3. Fetch from Firestore
    // ------------------------------------------------------------

    final future = _fetchPlacesFromFirestore(categoryId: categoryId);

    _pendingRequests[categoryId] = future;

    try {
      return await future;
    } finally {
      _pendingRequests.remove(categoryId);
    }
  }

  Future<Either<Failure, List<PlaceEntity>>> _fetchPlacesFromFirestore({
    required String categoryId,
  }) async {
    try {
      final data = await databaseService.getData(
        path: BackendEndpoint.placesPath,
        queries: [
          {'whereField': 'categoryId', 'whereValue': categoryId},
          {'whereField': 'status', 'whereValue': PlaceStatus.approved.name},
        ],
      ) as List<Map<String, dynamic>>;

      final places = data
          .map((json) => PlaceModel.fromJson(json).toEntity())
          .toList();

      // ----------------------------------------------------------
      // Save to Cache
      // ----------------------------------------------------------

      _placesCache[categoryId] = List<PlaceEntity>.from(places);

      return right(List<PlaceEntity>.from(places));
    } catch (e) {
      return left(ServerFailure('Failed to get places: $e'));
    }
  }

  // ============================================================
  // SEARCH
  // ============================================================

  @override
  Future<Either<Failure, List<PlaceEntity>>> searchPlaces({
    required String categoryId,
    required String searchQuery,
  }) async {
    /*
     * البحث الحقيقي أصبح Local في PlaceCubit.
     *
     * لكننا نحافظ على هذه method لأن PlaceRepo
     * غالبًا يحتوي عليها في الـ abstraction.
     *
     * هنا فقط نضمن أن البيانات نفسها تأتي من الـ cache
     * بدل ما نعمل Firestore query جديد كل مرة.
     */

    final result = await getPlaces(categoryId: categoryId);

    return result.fold((failure) => left(failure), (places) {
      final query = _normalizeArabic(searchQuery);

      if (query.isEmpty) {
        return right(places);
      }

      final filteredPlaces = places.where((place) {
        final placeName = _normalizeArabic(place.placeName);

        final placeAddress = _normalizeArabic(place.placeAddress);

        final placeDescription = _normalizeArabic(place.placeDescription);

        return placeName.contains(query) ||
            placeAddress.contains(query) ||
            placeDescription.contains(query);
      }).toList();

      return right(filteredPlaces);
    });
  }

  // ============================================================
  // ADD PLACE
  // ============================================================

  @override
  Future<Either<Failure, void>> addPlace({required PlaceEntity place}) async {
    try {
      // ----------------------------------------------------------
      // Get Current User
      // ----------------------------------------------------------

      final currentUser = firebaseAuthService.currentUser;

      if (currentUser == null) {
        return left(ServerFailure('يجب تسجيل الدخول أولاً لإضافة مكان.'));
      }

      // ----------------------------------------------------------
      // Create Place Entity with User ID
      // ----------------------------------------------------------

      final placeEntity = PlaceEntity(
        id: '',
        categoryId: place.categoryId,
        userId: currentUser.uid,
        placeName: place.placeName,
        placeAddress: place.placeAddress,
        placeDescription: place.placeDescription,
        phoneNumber: place.phoneNumber,
        latitude: place.latitude,
        longitude: place.longitude,
        status: PlaceStatus.pending,
        createdAt: place.createdAt,
        updatedAt: null,
        reviewedAt: null,
        reviewedBy: null,
        rejectionReason: null,
      );

      // ----------------------------------------------------------
      // Convert Entity -> Model
      // ----------------------------------------------------------

      final placeModel = PlaceModel.fromEntity(placeEntity);

      // ----------------------------------------------------------
      // Save to Firestore
      // ----------------------------------------------------------

      await databaseService.addData(
        path: BackendEndpoint.placesPath,
        data: placeModel.toJson(),
      );

      /*
       * لا نضيف المكان للـ cache هنا.
       *
       * لأن المكان أصبح Pending وليس Approved.
       */

      return right(null);
    } catch (e) {
      return left(ServerFailure('Failed to add place: $e'));
    }
  }

  // ============================================================
  // GET ALL PLACES
  // ============================================================

  @override
  Future<Either<Failure, List<PlaceEntity>>> getAllPlaces() async {
    try {
      final data = await databaseService.getData(
        path: BackendEndpoint.placesPath,
        queries: [
          {'whereField': 'status', 'whereValue': PlaceStatus.approved.name},
        ],
      ) as List<Map<String, dynamic>>;

      final places = data
          .map((json) => PlaceModel.fromJson(json).toEntity())
          .toList();

      return right(places);
    } catch (e) {
      return left(ServerFailure('Failed to get all places: $e'));
    }
  }

  // ============================================================
  // CACHE MANAGEMENT
  // ============================================================

  /// يمسح Cache Category معينة.
  ///
  /// هنحتاجها بعدين لو عاوز تعمل Refresh.
  void clearCategoryCache(String categoryId) {
    _placesCache.remove(categoryId);
  }

  /// يمسح كل الـ Cache.
  void clearAllCache() {
    _placesCache.clear();
  }

  /// هل الـ Category موجودة في الـ Cache؟
  bool hasCachedCategory(String categoryId) {
    return _placesCache.containsKey(categoryId);
  }

  // ============================================================
  // ARABIC NORMALIZATION
  // ============================================================

  String _normalizeArabic(String text) {
    return text
        .trim()
        .toLowerCase()
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  // ============================================================
  // GET MY PLACES
  // ============================================================

  @override
  Future<Either<Failure, List<PlaceEntity>>> getMyPlaces() async {
    try {
      // ----------------------------------------------------------
      // Get Current User
      // ----------------------------------------------------------

      final currentUser = firebaseAuthService.currentUser;

      if (currentUser == null) {
        return left(ServerFailure('يجب تسجيل الدخول أولاً.'));
      }

      // ----------------------------------------------------------
      // Get User Places
      // ----------------------------------------------------------

      final data = await databaseService.getData(
        path: BackendEndpoint.placesPath,
        queries: [
          {'whereField': 'userId', 'whereValue': currentUser.uid},
        ],
      ) as List<Map<String, dynamic>>;

      // ----------------------------------------------------------
      // Convert JSON -> Entity
      // ----------------------------------------------------------

      final places = data
          .map((json) => PlaceModel.fromJson(json).toEntity())
          .toList();

      return right(places);
    } catch (e) {
      return left(ServerFailure('Failed to get my places: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updatePlace({
    required PlaceEntity place,
  }) async {
    try {
      final currentUser = firebaseAuthService.currentUser;

      if (currentUser == null) {
        return left(ServerFailure('يجب تسجيل الدخول أولاً.'));
      }

      if (place.userId != currentUser.uid) {
        return left(ServerFailure('لا يمكنك تعديل هذا المكان.'));
      }

      await databaseService.updateData(
        path: BackendEndpoint.placesPath,
        documentId: place.id,
        data: {
          'categoryId': place.categoryId,
          'userId': currentUser.uid,
          'placeName': place.placeName,
          'placeAddress': place.placeAddress,
          'placeDescription': place.placeDescription,
          'phoneNumber': place.phoneNumber,
          'latitude': place.latitude,
          'longitude': place.longitude,

          // أي تعديل يرجع المكان للمراجعة.
          'status': PlaceStatus.pending.name,

          'updatedAt': FieldValue.serverTimestamp(),

          // إعادة ضبط بيانات المراجعة القديمة.
          'reviewedAt': null,
          'reviewedBy': null,
          'rejectionReason': null,
        },
      );

      return right(null);
    } catch (e) {
      return left(ServerFailure('حدث خطأ أثناء تعديل المكان.'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePlace({required String placeId}) async {
    try {
      final currentUser = firebaseAuthService.currentUser;

      if (currentUser == null) {
        return left(ServerFailure('يجب تسجيل الدخول أولاً.'));
      }

      await databaseService.deleteData(
        path: BackendEndpoint.placesPath,
        documentId: placeId,
      );

      return right(null);
    } catch (e) {
      return left(ServerFailure('حدث خطأ أثناء حذف المكان.'));
    }
  }
}
