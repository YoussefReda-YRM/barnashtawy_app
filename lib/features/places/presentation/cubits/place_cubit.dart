import 'dart:async';

import 'package:barnasht_app/core/helper_functions/normalize_arabic.dart';
import 'package:barnasht_app/core/services/location_service.dart';
import 'package:barnasht_app/features/places/domain/entities/place_entity.dart';
import 'package:barnasht_app/features/places/domain/repos/place_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:string_similarity/string_similarity.dart';

import 'place_state.dart';

enum PlaceDistanceFilter {
  all,
  oneHundredMeters,
  twoHundredFiftyMeters,
  fiveHundredMeters,
  oneKm,
  twoKm,
  threeKm,
  fiveKm,
}

extension PlaceDistanceFilterExtension on PlaceDistanceFilter {
  String get label {
    switch (this) {
      case PlaceDistanceFilter.all:
        return 'جميع الأماكن';
      case PlaceDistanceFilter.oneHundredMeters:
        return 'على بُعد 100 متر';
      case PlaceDistanceFilter.twoHundredFiftyMeters:
        return 'على بُعد 250 متر';
      case PlaceDistanceFilter.fiveHundredMeters:
        return 'على بُعد 500 متر';
      case PlaceDistanceFilter.oneKm:
        return 'على بُعد 1 كم';
      case PlaceDistanceFilter.twoKm:
        return 'على بُعد 2 كم';
      case PlaceDistanceFilter.threeKm:
        return 'على بُعد 3 كم';
      case PlaceDistanceFilter.fiveKm:
        return 'على بُعد 5 كم';
    }
  }

  double? get maxDistanceMeters {
    switch (this) {
      case PlaceDistanceFilter.all:
        return null;
      case PlaceDistanceFilter.oneHundredMeters:
        return 100;
      case PlaceDistanceFilter.twoHundredFiftyMeters:
        return 250;
      case PlaceDistanceFilter.fiveHundredMeters:
        return 500;
      case PlaceDistanceFilter.oneKm:
        return 1000;
      case PlaceDistanceFilter.twoKm:
        return 2000;
      case PlaceDistanceFilter.threeKm:
        return 3000;
      case PlaceDistanceFilter.fiveKm:
        return 5000;
    }
  }
}

class PlaceCubit extends Cubit<PlaceState> {
  PlaceCubit({required this.placeRepo, required this.locationService})
    : super(PlaceInitial());

  final PlaceRepo placeRepo;
  final LocationService locationService;

  // ============================================================
  // DATA
  // ============================================================

  /// الأماكن الأصلية الخاصة بالـ Category الحالية.
  List<PlaceEntity> _places = [];

  /// بيانات مجهزة مسبقًا للبحث.
  List<_SearchPlace> _searchPlaces = [];

  /// آخر Category تم تحميلها.
  String? _currentCategoryId;

  /// آخر نص بحث.
  String _searchQuery = '';

  /// فلتر المسافة الحالي.
  PlaceDistanceFilter _distanceFilter = PlaceDistanceFilter.all;

  /// موقع المستخدم الحالي.
  Position? _userPosition;

  /// Debounce للبحث.
  Timer? _searchDebounce;

  /// يمنع تشغيل أكثر من طلب للحصول على الموقع في نفس الوقت.
  Future<Position?>? _locationFuture;

  /// رقم الطلب الحالي.
  ///
  /// نستخدمه للتأكد أن تحديث الموقع في الخلفية
  /// يخص الـ Category الحالية وليس Category قديمة.
  int _requestId = 0;

  /// لو المكانين قريبين جدًا من بعض في المسافة،
  /// نستخدم createdAt كـ tie breaker.
  ///
  /// 50 متر تعتبر مسافة متقاربة في ترتيب النتائج.
  static const double _sameDistanceThresholdMeters = 50;

  // ============================================================
  // GETTERS
  // ============================================================

  PlaceDistanceFilter get distanceFilter => _distanceFilter;

  String get distanceFilterLabel => _distanceFilter.label;

  // ============================================================
  // GET PLACES
  // ============================================================

  Future<void> getPlaces({required String categoryId}) async {
    final isNewCategory = _currentCategoryId != categoryId;

    if (isNewCategory) {
      _currentCategoryId = categoryId;
      _searchDebounce?.cancel();

      _searchQuery = '';
      _distanceFilter = PlaceDistanceFilter.all;
      _userPosition = null;

      emit(PlaceLoading());
    }

    final int currentRequestId = ++_requestId;

    final result = await placeRepo.getPlaces(categoryId: categoryId);

    if (isClosed || currentRequestId != _requestId) {
      return;
    }

    await result.fold(
      (failure) async {
        if (isClosed || currentRequestId != _requestId) {
          return;
        }

        emit(PlaceFailure(errorMessage: failure.message));
      },
      (places) async {
        if (isClosed || currentRequestId != _requestId) {
          return;
        }

        _setPlaces(places);

        // ========================================================
        // IMPORTANT:
        // عرض الأماكن فورًا بدون انتظار Location.
        // ========================================================

        emit(PlaceSuccess(places: _buildVisiblePlaces()));

        // ========================================================
        // تحميل Location في الخلفية.
        //
        // لا نستخدم await هنا حتى لا يتأخر ظهور الأماكن.
        // بمجرد وصول الموقع سيتم إعادة ترتيب القائمة.
        // ========================================================

        unawaited(
          _loadUserPositionInBackground(
            categoryId: categoryId,
            requestId: currentRequestId,
          ),
        );
      },
    );
  }

  // ============================================================
  // SET PLACES
  // ============================================================

  void _setPlaces(List<PlaceEntity> places) {
    _places = List<PlaceEntity>.from(places);

    _searchPlaces = _places.map((place) {
      return _SearchPlace(
        place: place,
        name: normalizeArabic(place.placeName),
        address: normalizeArabic(place.placeAddress),
        description: normalizeArabic(place.placeDescription),
      );
    }).toList();
  }

  // ============================================================
  // LOCATION
  // ============================================================

  Future<void> _loadUserPositionInBackground({
    required String categoryId,
    required int requestId,
  }) async {
    final position = await _getUserPosition();

    if (position == null) {
      return;
    }

    if (isClosed) {
      return;
    }

    // المستخدم انتقل إلى Category أخرى.
    if (_currentCategoryId != categoryId) {
      return;
    }

    // هذا طلب قديم.
    if (requestId != _requestId) {
      return;
    }

    _userPosition = position;

    // ==========================================================
    // الموقع وصل الآن.
    //
    // نعيد تطبيق:
    // Search
    // +
    // Distance Filter
    // +
    // Distance Sorting
    // ==========================================================

    _emitCurrentResults();
  }

  Future<Position?> _getUserPosition() {
    if (_userPosition != null) {
      return Future.value(_userPosition);
    }

    // لو فيه طلب Location شغال بالفعل،
    // نستخدم نفس الطلب بدل عمل طلب جديد.
    if (_locationFuture != null) {
      return _locationFuture!;
    }

    _locationFuture = _fetchUserPosition();

    final future = _locationFuture!;

    future.whenComplete(() {
      if (_locationFuture == future) {
        _locationFuture = null;
      }
    });

    return future;
  }

  Future<Position?> _fetchUserPosition() async {
    try {
      final hasAccess = await locationService.hasRequiredAccess();

      if (!hasAccess) {
        return null;
      }

      return await locationService.getCurrentPosition();
    } catch (_) {
      return null;
    }
  }

  Future<bool> _ensureUserPosition() async {
    if (_userPosition != null) {
      return true;
    }

    final position = await _getUserPosition();

    if (position == null) {
      return false;
    }

    _userPosition = position;

    return true;
  }

  // ============================================================
  // DISTANCE FILTER
  // ============================================================

  Future<bool> setDistanceFilter(PlaceDistanceFilter filter) async {
    _searchDebounce?.cancel();

    // جميع الأماكن لا تحتاج إلى Location.
    if (filter == PlaceDistanceFilter.all) {
      _distanceFilter = filter;

      _emitCurrentResults();

      return true;
    }

    // فلاتر المسافة تحتاج موقع المستخدم.
    final hasPosition = await _ensureUserPosition();

    if (!hasPosition) {
      return false;
    }

    if (isClosed) {
      return false;
    }

    _distanceFilter = filter;

    _emitCurrentResults();

    return true;
  }

  // ============================================================
  // SEARCH
  // ============================================================

  void searchPlaces({required String searchQuery}) {
    _searchDebounce?.cancel();

    final query = searchQuery.trim();

    _searchQuery = query;

    // ----------------------------------------------------------
    // Empty Search
    // ----------------------------------------------------------

    if (query.isEmpty) {
      _emitCurrentResults();
      return;
    }

    // ----------------------------------------------------------
    // Debounce
    // ----------------------------------------------------------

    _searchDebounce = Timer(const Duration(milliseconds: 150), () {
      _performSearch(query);
    });
  }

  // ============================================================
  // PERFORM SEARCH
  // ============================================================

  void _performSearch(String rawQuery) {
    if (isClosed) {
      return;
    }

    final query = normalizeArabic(rawQuery);

    if (query.isEmpty) {
      _emitCurrentResults();
      return;
    }

    final results = <PlaceEntity>[];

    // ----------------------------------------------------------
    // First Pass: Direct Search
    // ----------------------------------------------------------

    for (final item in _searchPlaces) {
      final directMatch =
          item.name.contains(query) ||
          item.address.contains(query) ||
          item.description.contains(query);

      if (directMatch) {
        results.add(item.place);
      }
    }

    // ----------------------------------------------------------
    // Second Pass: Fuzzy Search
    // ----------------------------------------------------------

    if (results.isEmpty && query.length >= 3) {
      for (final item in _searchPlaces) {
        if (_isSimilar(text: item.name, query: query)) {
          results.add(item.place);
          continue;
        }

        if (_isSimilar(text: item.address, query: query)) {
          results.add(item.place);
        }
      }
    }

    // ----------------------------------------------------------
    // Apply Distance Filter + Sorting
    // ----------------------------------------------------------

    final visibleResults = _applyDistanceAndSort(results);

    emit(PlaceSearching(places: visibleResults, searchQuery: rawQuery.trim()));
  }

  // ============================================================
  // BUILD VISIBLE PLACES
  // ============================================================

  List<PlaceEntity> _buildVisiblePlaces() {
    if (_searchQuery.isEmpty) {
      return _applyDistanceAndSort(List<PlaceEntity>.from(_places));
    }

    final query = normalizeArabic(_searchQuery);

    final results = <PlaceEntity>[];

    // Direct search
    for (final item in _searchPlaces) {
      final directMatch =
          item.name.contains(query) ||
          item.address.contains(query) ||
          item.description.contains(query);

      if (directMatch) {
        results.add(item.place);
      }
    }

    // Fuzzy search
    if (results.isEmpty && query.length >= 3) {
      for (final item in _searchPlaces) {
        if (_isSimilar(text: item.name, query: query)) {
          results.add(item.place);
          continue;
        }

        if (_isSimilar(text: item.address, query: query)) {
          results.add(item.place);
        }
      }
    }

    return _applyDistanceAndSort(results);
  }

  // ============================================================
  // EMIT CURRENT RESULTS
  // ============================================================

  void _emitCurrentResults() {
    if (isClosed) {
      return;
    }

    final places = _buildVisiblePlaces();

    if (_searchQuery.isEmpty) {
      emit(PlaceSuccess(places: places));
    } else {
      emit(PlaceSearching(places: places, searchQuery: _searchQuery));
    }
  }

  // ============================================================
  // DISTANCE + SORTING
  // ============================================================

  List<PlaceEntity> _applyDistanceAndSort(List<PlaceEntity> places) {
    final position = _userPosition;

    // لو الموقع غير متاح:
    // - جميع الأماكن تظل تعمل.
    // - لا نستطيع حساب المسافة.
    // - القائمة تظهر فورًا بدون انتظار Location.
    if (position == null) {
      return List<PlaceEntity>.from(places);
    }

    final placesWithDistance = places.map((place) {
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        place.latitude,
        place.longitude,
      );

      return _PlaceWithDistance(place: place, distanceMeters: distance);
    }).toList();

    // ----------------------------------------------------------
    // Distance Filter
    // ----------------------------------------------------------

    final maxDistance = _distanceFilter.maxDistanceMeters;

    if (maxDistance != null) {
      placesWithDistance.removeWhere(
        (item) => item.distanceMeters > maxDistance,
      );
    }

    // ----------------------------------------------------------
    // Sorting
    // ----------------------------------------------------------
    //
    // 1. الأقرب أولًا.
    // 2. إذا كان الفرق بين المكانين <= 50 متر:
    //    الأحدث أولًا.
    //

    placesWithDistance.sort((a, b) {
      final distanceDifference = a.distanceMeters - b.distanceMeters;

      if (distanceDifference.abs() > _sameDistanceThresholdMeters) {
        return distanceDifference.compareTo(0);
      }

      return b.place.createdAt.compareTo(a.place.createdAt);
    });

    return placesWithDistance.map((item) => item.place).toList();
  }

  // ============================================================
  // FUZZY SEARCH
  // ============================================================

  bool _isSimilar({required String text, required String query}) {
    if (text.contains(query)) {
      return true;
    }

    final textWords = text.split(' ');
    final queryWords = query.split(' ');

    for (final queryWord in queryWords) {
      if (queryWord.length < 3) {
        continue;
      }

      for (final textWord in textWords) {
        if (textWord.length < 3) {
          continue;
        }

        final similarity = textWord.similarityTo(queryWord);

        if (similarity >= 0.70) {
          return true;
        }
      }
    }

    return false;
  }

  // ============================================================
  // CLEAR SEARCH
  // ============================================================

  void clearSearch() {
    _searchDebounce?.cancel();

    _searchQuery = '';

    _emitCurrentResults();
  }

  // ============================================================
  // ADD PLACE
  // ============================================================

  Future<void> addPlace({required PlaceEntity place}) async {
    emit(PlaceAdding());

    final result = await placeRepo.addPlace(place: place);

    result.fold(
      (failure) {
        emit(PlaceAddFailure(errorMessage: failure.message));
      },
      (_) {
        emit(PlaceAdded());
      },
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  Future<void> close() {
    _searchDebounce?.cancel();

    return super.close();
  }
}

// ================================================================
// SEARCH MODEL
// ================================================================

class _SearchPlace {
  final PlaceEntity place;

  final String name;
  final String address;
  final String description;

  const _SearchPlace({
    required this.place,
    required this.name,
    required this.address,
    required this.description,
  });
}

// ================================================================
// PLACE + DISTANCE
// ================================================================

class _PlaceWithDistance {
  final PlaceEntity place;
  final double distanceMeters;

  const _PlaceWithDistance({required this.place, required this.distanceMeters});
}
