import 'package:barnasht_app/core/services/shared_preferences_singleton.dart';

class FavoriteService {
  static const String _favoritePlacesKey = 'favorite_places';

  static List<String> getFavoritePlaceIds() {
    return Prefs.getStringList(_favoritePlacesKey);
  }

  static bool isFavorite(String placeId) {
    final favoriteIds = getFavoritePlaceIds();

    return favoriteIds.contains(placeId);
  }

  static Future<bool> toggleFavorite(String placeId) async {
    final favoriteIds = getFavoritePlaceIds();

    if (favoriteIds.contains(placeId)) {
      favoriteIds.remove(placeId);

      await Prefs.setStringList(_favoritePlacesKey, favoriteIds);

      return false;
    }

    favoriteIds.add(placeId);

    await Prefs.setStringList(_favoritePlacesKey, favoriteIds);

    return true;
  }
}
