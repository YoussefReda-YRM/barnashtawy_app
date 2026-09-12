import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class MyPlacesHeaderWidget extends StatelessWidget {
  const MyPlacesHeaderWidget({
    super.key,
    required this.colorScheme,
    required this.placesCount,
  });

  final ColorScheme colorScheme;
  final int placesCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'أماكني',
                style: TextStyles.bold19.copyWith(color: colorScheme.onSurface),
              ),
              const SizedBox(height: 3),
              Text(
                'الأماكن التي قمت بطلب إضافتها إلى برنشتاوي',
                style: TextStyles.regular11.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$placesCount',
            style: TextStyles.bold13.copyWith(color: colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
