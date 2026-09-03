import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomEmptyPlacesWidget extends StatelessWidget {
  const CustomEmptyPlacesWidget({
    super.key,
    this.title = 'مفيش أماكن لسه',
    this.subtitle =
        'لسه محدش أضاف مكان في التصنيف ده.\nخليك أول واحد يضيفه 🌱',
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 40,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ==========================================================
            // ICON CONTAINER
            // ==========================================================

            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(
                  alpha: 0.08,
                ),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(
                        alpha: 0.10,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),

                  Icon(
                    Icons.location_off_rounded,
                    size: 36,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ==========================================================
            // TITLE
            // ==========================================================

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyles.semiBold16.copyWith(
                color: colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 8),

            // ==========================================================
            // SUBTITLE
            // ==========================================================

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyles.regular13.copyWith(
                color: colorScheme.onSurface.withValues(
                  alpha: 0.60,
                ),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}