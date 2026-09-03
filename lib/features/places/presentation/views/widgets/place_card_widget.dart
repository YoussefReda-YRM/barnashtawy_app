import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:barnasht_app/features/places/domain/entities/place_entity.dart';
import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

class PlaceCard extends StatelessWidget {
  const PlaceCard({
    super.key,
    required this.place,
    this.onTap,
    this.onLocationPressed,
    this.onFavoritePressed,
    required this.placeImage,
    this.isFavorite = false,
  });

  final PlaceEntity place;
  final VoidCallback? onTap;
  final VoidCallback? onLocationPressed;
  final VoidCallback? onFavoritePressed;
  final String placeImage;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Favorite is a semantic color, so it remains red in both themes.
    final favoriteColor = colorScheme.error;
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
              color: colorScheme.primary.withValues(alpha: 0.25),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.07),
                blurRadius: 14,
                spreadRadius: 1,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: placeImage.trim().isNotEmpty
                            ? SvgPicture.asset(placeImage, fit: BoxFit.contain)
                            : Icon(
                                Icons.place_outlined,
                                size: 28,
                                color: colorScheme.primary,
                              ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place.placeName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.semiBold16.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            place.placeDescription,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.regular11.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.60,
                              ),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    InkWell(
                      onTap: onFavoritePressed,
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: favoriteColor.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: favoriteColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Divider(
                  height: 1,
                  thickness: 1,
                  color: colorScheme.primary.withValues(alpha: 0.08),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.09),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.location_on_outlined,
                        color: colorScheme.primary,
                        size: 18,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        place.placeAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.regular11.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    InkWell(
                      onTap: onLocationPressed,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.navigation_rounded,
                              size: 15,
                              color: colorScheme.primary,
                            ),

                            const SizedBox(width: 5),

                            Text(
                              'الوصول للمكان',
                              style: TextStyles.semiBold11.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
