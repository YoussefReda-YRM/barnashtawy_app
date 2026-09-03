import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomEmptySearchWidget extends StatelessWidget {
  const CustomEmptySearchWidget({
    super.key,
    this.searchQuery,
  });

  final String? searchQuery;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ==========================================================
            // SEARCH ICON
            // ==========================================================

            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Icon(
                    Icons.search_off_rounded,
                    size: 38,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ==========================================================
            // TITLE
            // ==========================================================

            Text(
              'ملقيناش اللي بتدور عليه',
              textAlign: TextAlign.center,
              style: TextStyles.semiBold16.copyWith(
                color: colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 9),

            // ==========================================================
            // DESCRIPTION
            // ==========================================================

            Text(
              searchQuery != null && searchQuery!.trim().isNotEmpty
                  ? 'مفيش نتائج مطابقة لـ "${searchQuery!.trim()}"'
                  : 'مفيش نتائج مطابقة لبحثك حاليًا',
              textAlign: TextAlign.center,
              style: TextStyles.regular13.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.60),
                height: 1.6,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'جرّب كلمة بحث مختلفة أو أبسط.',
              textAlign: TextAlign.center,
              style: TextStyles.regular11.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}