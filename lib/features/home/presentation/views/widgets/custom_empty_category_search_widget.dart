import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomEmptyCategorySearchWidget extends StatelessWidget {
  const CustomEmptyCategorySearchWidget({
    super.key,
    this.searchQuery,
  });

  final String? searchQuery;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final query = searchQuery?.trim();

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                    Icons.category_outlined,
                    size: 38,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            Text(
              'ملقيناش التصنيف اللي بتدور عليه',
              textAlign: TextAlign.center,
              style: TextStyles.semiBold16.copyWith(
                color: colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 9),

            Text(
              query != null && query.isNotEmpty
                  ? 'مفيش تصنيف مطابق لـ "$query"'
                  : 'مفيش تصنيفات مطابقة لبحثك حاليًا',
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