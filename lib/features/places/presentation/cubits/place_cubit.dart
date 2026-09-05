import 'dart:async';

import 'package:barnasht_app/core/helper_functions/normalize_arabic.dart';
import 'package:barnasht_app/features/places/domain/entities/place_entity.dart';
import 'package:barnasht_app/features/places/domain/repos/place_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_similarity/string_similarity.dart';

import 'place_state.dart';

class PlaceCubit extends Cubit<PlaceState> {
  PlaceCubit({required this.placeRepo}) : super(PlaceInitial());

  final PlaceRepo placeRepo;

  // ============================================================
  // DATA
  // ============================================================

  /// الأماكن الأصلية.
  List<PlaceEntity> _places = [];

  /// بيانات مجهزة مسبقًا للبحث.
  ///
  /// الـ normalize بيتم مرة واحدة عند تحميل البيانات،
  /// وليس مع كل عملية بحث.
  List<_SearchPlace> _searchPlaces = [];

  /// آخر Category تم تحميلها.
  String? _currentCategoryId;

  /// Debounce للبحث أثناء الكتابة.
  Timer? _searchDebounce;

  // ============================================================
  // GET PLACES
  // ============================================================

  Future<void> getPlaces({required String categoryId}) async {
    final isNewCategory = _currentCategoryId != categoryId;

    if (isNewCategory) {
      _currentCategoryId = categoryId;
      _searchDebounce?.cancel();

      emit(PlaceLoading());
    }

    final result = await placeRepo.getPlaces(categoryId: categoryId);

    result.fold(
      (failure) {
        emit(PlaceFailure(errorMessage: failure.message));
      },
      (places) {
        _setPlaces(places);

        emit(PlaceSuccess(places: List<PlaceEntity>.from(_places)));
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

        // Normalize مرة واحدة فقط.
        name: normalizeArabic(place.placeName),
        address: normalizeArabic(place.placeAddress),
        description: normalizeArabic(place.placeDescription),
      );
    }).toList();
  }

  // ============================================================
  // SEARCH
  // ============================================================

  void searchPlaces({required String searchQuery}) {
    _searchDebounce?.cancel();

    final query = searchQuery.trim();

    // ----------------------------------------------------------
    // Empty Search
    // ----------------------------------------------------------

    if (query.isEmpty) {
      emit(PlaceSuccess(places: List<PlaceEntity>.from(_places)));

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
    final query = normalizeArabic(rawQuery);

    if (query.isEmpty) {
      emit(PlaceSuccess(places: List<PlaceEntity>.from(_places)));

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
    //
    // نستخدمه فقط إذا لم نجد نتائج مباشرة.
    // وده يقلل جدًا العمليات الحسابية.
    //

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

    emit(PlaceSearching(places: results, searchQuery: rawQuery.trim()));
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

    emit(PlaceSuccess(places: List<PlaceEntity>.from(_places)));
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
        // المكان Pending، لذلك لا نضيفه إلى
        // قائمة الأماكن Approved.

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
