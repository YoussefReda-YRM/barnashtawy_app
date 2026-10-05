import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class LocationUtils {
  LocationUtils._();

  static Future<String?> getLocationName(LatLng location) async {
    try {
      final Uri uri = Uri.https('nominatim.openstreetmap.org', '/reverse', {
        'format': 'jsonv2',
        'lat': location.latitude.toString(),
        'lon': location.longitude.toString(),
        'zoom': '18',
        'addressdetails': '1',
        'accept-language': 'ar',
      });

      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'Barnashtawy/1.0 (Flutter app)',
          'Accept': 'application/json',
        },
      );

      debugPrint('Nominatim status code: ${response.statusCode}');

      if (response.statusCode != 200) {
        debugPrint('❌ Nominatim error: ${response.body}');
        return null;
      }

      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;

      final String? displayName = data['display_name'] as String?;

      if (displayName == null || displayName.trim().isEmpty) {
        return null;
      }

      return displayName.trim();
    } catch (e) {
      debugPrint('❌ Nominatim reverse geocoding error: $e');
      return null;
    }
  }
}
