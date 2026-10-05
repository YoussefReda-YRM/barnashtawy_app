import 'package:barnasht_app/core/utils/app_images.dart';
import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:barnasht_app/features/home/domain/entities/category_entities.dart';
import 'package:flutter/material.dart';

class HomeCategoryCard extends StatelessWidget {
  const HomeCategoryCard({super.key, required this.category, this.onTap});

  final CategoryEntity category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.6),
              width: 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.12),
                blurRadius: 16,
                spreadRadius: 1,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final imageSize = constraints.maxWidth * 0.55;

                      return Center(
                        child: SizedBox(
                          width: imageSize,
                          height: imageSize,
                          child: category.image.isEmpty
                              ? Image.asset(
                                  Assets.imagesAppLogoTransparent,
                                  fit: BoxFit.contain,
                                )
                              : Image.asset(
                                  category.image,
                                  fit: BoxFit.contain,
                                ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          category.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.bold13.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),

                      const SizedBox(width: 6),

                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 13,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
