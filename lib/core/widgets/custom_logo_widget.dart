import 'package:barnasht_app/core/utils/app_images.dart';
import 'package:flutter/material.dart';

class CustomLogoWidget extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Image.asset(Assets.imagesAppLogoTransparent, width: 60, height: 60),
    );
  }
}
