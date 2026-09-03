import 'package:barnasht_app/core/helper_functions/normalize_arabic.dart';
import 'package:barnasht_app/features/places/domain/entities/place_entity.dart';
import 'package:barnasht_app/features/places/domain/repos/place_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_similarity/string_similarity.dart';

import 'place_state.dart';

class PlaceCubit extends Cubit<PlaceState> {
  PlaceCubit({required this.placeRepo}) : super(PlaceInitial());

  final PlaceRepo placeRepo;

  /// الأماكن الأصلية.
  List<PlaceEntity> _places = [];

  /// النصوص المجهزة للبحث.
  ///
  /// كل عنصر هنا مرتبط بنفس index الموجود في _places.
  List<String> _normalizedPlaceNames = [];
  final List<String> _normalizedPlaceDescriptions = [];

  /// آخر كلمة بحث.
  String _currentSearchQuery = '';

  // ============================================================
  // GET PLACES
  // ============================================================

  Future<void> getPlaces({required String categoryId}) async {
    emit(PlaceLoading());

    final result = await placeRepo.getPlaces(categoryId: categoryId);

    result.fold(
      (failure) {
        emit(PlaceFailure(errorMessage: failure.message));
      },
      (places) {
        _places = List<PlaceEntity>.from(places);

        // تجهيز الاسم للبحث
        _normalizedPlaceNames = _places
            .map((place) => normalizeArabic(place.placeName))
            .toList();

        // تجهيز الوصف للبحث
        _normalizedPlaceDescriptions
          ..clear()
          ..addAll(
            _places.map((place) => normalizeArabic(place.placeDescription)),
          );

        emit(PlaceSuccess(places: List<PlaceEntity>.from(_places)));
      },
    );
  }

  bool _isSimilar(String text, String query) {
    final normalizedText = normalizeArabic(text);
    final normalizedQuery = normalizeArabic(query);

    // تطابق مباشر
    if (normalizedText.contains(normalizedQuery)) {
      return true;
    }

    final textWords = normalizedText.split(' ');
    final queryWords = normalizedQuery.split(' ');

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
  // SEARCH PLACES
  // ============================================================

  void searchPlaces({required String searchQuery}) {
    final query = searchQuery.trim();

    _currentSearchQuery = query;

    // ------------------------------------------------------------
    // Empty Search
    // ------------------------------------------------------------

    if (query.isEmpty) {
      emit(PlaceSuccess(places: List<PlaceEntity>.from(_places)));

      return;
    }

    // ------------------------------------------------------------
    // Search
    // ------------------------------------------------------------

    final results = <PlaceEntity>[];

    for (final place in _places) {
      final nameMatches = _isSimilar(place.placeName, query);

      final descriptionMatches = _isSimilar(place.placeDescription, query);

      if (nameMatches || descriptionMatches) {
        results.add(place);
      }
    }

    // ------------------------------------------------------------
    // Emit Results
    // ------------------------------------------------------------

    emit(PlaceSearching(places: results, searchQuery: query));
  }
  // ============================================================
  // CLEAR SEARCH
  // ============================================================

  void clearSearch() {
    _currentSearchQuery = '';

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
        _places.add(place);

        // تجهيز الاسم الجديد للبحث.
        _normalizedPlaceNames.add(normalizeArabic(place.placeName));

        emit(PlaceAdded());

        if (_currentSearchQuery.isEmpty) {
          emit(PlaceSuccess(places: List<PlaceEntity>.from(_places)));
        } else {
          searchPlaces(searchQuery: _currentSearchQuery);
        }
      },
    );
  }
}
