import 'package:barnasht_app/core/constatnts.dart';
import 'package:barnasht_app/core/errors/failures.dart';
import 'package:barnasht_app/core/services/database_service.dart';
import 'package:barnasht_app/features/places/data/models/place_model.dart';
import 'package:barnasht_app/features/places/domain/entities/place_entity.dart';
import 'package:barnasht_app/features/places/domain/repos/place_repo.dart';
import 'package:dartz/dartz.dart';

class PlaceRepoImpl extends PlaceRepo {
  final DatabaseService databaseService;

  PlaceRepoImpl(this.databaseService);

  // ============================================================
  // GET APPROVED PLACES
  // ============================================================

  @override
  Future<Either<Failure, List<PlaceEntity>>> getPlaces({
    required String categoryId,
  }) async {
    try {
      final data = await databaseService.getData(
        path: placesPath,
        queries: [
          {'whereField': 'categoryId', 'whereValue': categoryId},
          {'whereField': 'status', 'whereValue': PlaceStatus.approved.name},
        ],
      ) as List<Map<String, dynamic>>;

      final places = data
          .map((json) => PlaceModel.fromJson(json).toEntity())
          .toList();

      return right(places);
    } catch (e) {
      return left(ServerFailure('Failed to get places: $e'));
    }
  }

  // ============================================================
  // ADD PLACE
  // ============================================================

  @override
  Future<Either<Failure, void>> addPlace({required PlaceEntity place}) async {
    try {
      final placeModel = PlaceModel(
        id: '',
        categoryId: place.categoryId,
        placeName: place.placeName,
        placeAddress: place.placeAddress,
        placeDescription: place.placeDescription,
        latitude: place.latitude,
        longitude: place.longitude,
        status: PlaceStatus.pending,
        createdAt: place.createdAt,
      );

      await databaseService.addData(
        path: placesPath,
        data: placeModel.toJson(),
      );

      return right(null);
    } catch (e) {
      return left(ServerFailure('Failed to add place: $e'));
    }
  }

  // ============================================================
  // SEARCH APPROVED PLACES
  // ============================================================

  @override
  Future<Either<Failure, List<PlaceEntity>>> searchPlaces({
    required String categoryId,
    required String searchQuery,
  }) async {
    try {
      // ----------------------------------------------------------
      // Get only approved places from Firestore
      // ----------------------------------------------------------

      final data = await databaseService.getData(
        path: placesPath,
        queries: [
          {'whereField': 'categoryId', 'whereValue': categoryId},
          {'whereField': 'status', 'whereValue': PlaceStatus.approved.name},
        ],
      ) as List<Map<String, dynamic>>;

      final places = data
          .map((json) => PlaceModel.fromJson(json).toEntity())
          .toList();

      // ----------------------------------------------------------
      // Normalize search query
      // ----------------------------------------------------------

      final query = _normalizeArabic(searchQuery);

      // البحث فاضي
      if (query.isEmpty) {
        return right(places);
      }

      // ----------------------------------------------------------
      // Local search
      // ----------------------------------------------------------

      final filteredPlaces = places.where((place) {
        final placeName = _normalizeArabic(place.placeName);
        final placeAddress = _normalizeArabic(place.placeAddress);
        final placeDescription = _normalizeArabic(place.placeDescription);

        return placeName.contains(query) ||
            placeAddress.contains(query) ||
            placeDescription.contains(query);
      }).toList();

      return right(filteredPlaces);
    } catch (e) {
      return left(ServerFailure('Failed to search places: $e'));
    }
  }

  // ============================================================
  // ARABIC SEARCH NORMALIZATION
  // ============================================================

  String _normalizeArabic(String text) {
    return text
        .trim()
        .toLowerCase()
        // أ / إ / آ → ا
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        // ة → ه
        .replaceAll('ة', 'ه')
        // ى → ي
        .replaceAll('ى', 'ي')
        // إزالة التشكيل
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '')
        // إزالة المسافات الزائدة
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> getAllPlaces() async {
    try {
      final data = await databaseService.getData(
        path: placesPath,
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
}
