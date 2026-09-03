import 'package:barnasht_app/core/services/shared_preferences_singleton.dart';
import 'package:barnasht_app/features/places/presentation/cubits/favorite_place_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteInitial());

  static const String _favoritePlacesKey = 'favorite_places';

  // ============================================================
  // LOAD FAVORITES
  // ============================================================

  void loadFavorites() {
    final favoriteIds = Prefs.getStringList(_favoritePlacesKey);

    emit(
      FavoriteLoaded(
        favoritePlaceIds: favoriteIds.toSet(),
      ),
    );
  }

  // ============================================================
  // CHECK FAVORITE
  // ============================================================

  bool isFavorite(String placeId) {
    if (state is! FavoriteLoaded) {
      return false;
    }

    final currentState = state as FavoriteLoaded;

    return currentState.favoritePlaceIds.contains(placeId);
  }

  // ============================================================
  // TOGGLE FAVORITE
  // ============================================================

  Future<void> toggleFavorite(String placeId) async {
    Set<String> favoriteIds;

    if (state is FavoriteLoaded) {
      favoriteIds = Set<String>.from(
        (state as FavoriteLoaded).favoritePlaceIds,
      );
    } else {
      favoriteIds = Prefs.getStringList(_favoritePlacesKey).toSet();
    }

    if (favoriteIds.contains(placeId)) {
      favoriteIds.remove(placeId);
    } else {
      favoriteIds.add(placeId);
    }

    await Prefs.setStringList(
      _favoritePlacesKey,
      favoriteIds.toList(),
    );

    emit(
      FavoriteLoaded(
        favoritePlaceIds: favoriteIds,
      ),
    );
  }
}