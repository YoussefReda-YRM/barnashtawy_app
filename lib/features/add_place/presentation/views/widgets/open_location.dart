import 'package:barnasht_app/core/constatnts.dart';
import 'package:barnasht_app/features/places/domain/entities/place_entity.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openLocation(BuildContext context, PlaceEntity place) async {
  final Uri googleMapsUrl = Uri.https(googleMapUrl, '/maps/dir/', {
    'api': '1',
    'destination': '${place.latitude},${place.longitude}',
  });

  try {
    final bool launched = await launchUrl(
      googleMapsUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('تعذر فتح خرائط Google')));
    }
  } catch (e) {
    debugPrint('Google Maps Error: $e');

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء فتح الخريطة')),
      );
    }
  }
}
