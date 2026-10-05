import 'package:barnasht_app/core/utils/app_images.dart';
import 'package:flutter/material.dart';

class PermissionTopBrand extends StatelessWidget {
  const PermissionTopBrand({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 42,
          height: 42,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Image.asset(
            Assets.imagesAppLogoTransparent,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 11),
        Text(
          'برنشتاوي',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}