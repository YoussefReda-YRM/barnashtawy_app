import 'package:barnasht_app/core/utils/app_images.dart';
import 'package:flutter/material.dart';

class CustomLogoWidget extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(Assets.imagesAppLogoTransparent, width: 70, height: 70);
  }
}
