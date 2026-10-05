import 'package:barnasht_app/core/utils/app_colors.dart';
import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:barnasht_app/features/home/domain/entities/category_entities.dart';
import 'package:barnasht_app/features/home/presentation/views/widgets/home_categroy_card.dart';
import 'package:barnasht_app/features/places/presentation/views/place_view.dart';
import 'package:flutter/material.dart';

class HomeCategoryGrideView extends StatelessWidget {
  const HomeCategoryGrideView({
    super.key,
    required this.categories,
    this.onSeeMore,
  });

  final List<CategoryEntity> categories;
  final VoidCallback? onSeeMore;

  @override
  Widget build(BuildContext context) {
    final visibleCategories = categories.take(6).toList();

    return SliverMainAxisGroup(
      slivers: [
        // عنوان القسم + عرض كل التصنيفات
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'استكشف الأماكن',
                    style: TextStyles.semiBold16,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                if (categories.length > 6) ...[
                  const SizedBox(width: 12),

                  InkWell(
                    onTap: onSeeMore,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 4,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'عرض المزيد',
                            style: TextStyles.semiBold11.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 11,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // التصنيفات
        SliverLayoutBuilder(
          builder: (context, constraints) {
            const spacing = 12.0;
            const maxCardWidth = 180.0;

            final availableWidth = constraints.crossAxisExtent;

            final crossAxisCount =
                (availableWidth + spacing) ~/ (maxCardWidth + spacing);

            final actualCrossAxisCount = crossAxisCount.clamp(2, 4);

            final cardWidth =
                (availableWidth - (actualCrossAxisCount - 1) * spacing) /
                actualCrossAxisCount;

            final cardHeight = cardWidth * 0.9;

            return SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: actualCrossAxisCount,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                mainAxisExtent: cardHeight,
              ),
              itemCount: visibleCategories.length,
              itemBuilder: (context, index) {
                final category = visibleCategories[index];

                return HomeCategoryCard(
                  category: category,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      PlaceView.routeName,
                      arguments: category,
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}
