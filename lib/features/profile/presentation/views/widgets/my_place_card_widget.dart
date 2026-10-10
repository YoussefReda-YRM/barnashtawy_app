import 'package:barnasht_app/core/helper_functions/mak_phone_call.dart';
import 'package:barnasht_app/core/helper_functions/open_location.dart';
import 'package:barnasht_app/core/utils/app_colors.dart';
import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:barnasht_app/features/home/domain/entities/category_entities.dart';
import 'package:barnasht_app/features/places/domain/entities/place_entity.dart';
import 'package:barnasht_app/features/profile/presentation/views/widgets/place_action_buston.dart';
import 'package:barnasht_app/features/profile/presentation/views/widgets/status_badge_widget.dart';
import 'package:flutter/material.dart';

class MyPlaceCard extends StatelessWidget {
  const MyPlaceCard({
    super.key,
    required this.place,
    required this.category,
    required this.status,
    required this.statusColor,
    required this.onEdit,
    required this.onDelete,
  });

  final PlaceEntity place;
  final CategoryEntity category;
  final String status;
  final Color statusColor;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final categoryName = category.name;
    final categoryImage = category.image;

    final hasPhoneNumber =
        place.phoneNumber != null && place.phoneNumber!.trim().isNotEmpty;

    final cardColor = theme.brightness == Brightness.dark
        ? AppColors.darkCard
        : AppColors.lightSurface;

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.25),
            width: 1.1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: theme.brightness == Brightness.dark ? 0.20 : 0.06,
              ),
              blurRadius: 14,
              spreadRadius: 1,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Column(
            children: [
              // ============================================================
              // HEADER
              // ============================================================
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
                      padding: const EdgeInsets.all(6),
                      child: categoryImage.trim().isNotEmpty
                          ? Image.asset(
                              categoryImage,
                              fit: BoxFit.contain,
                              errorBuilder: (_, _, _) {
                                return Icon(
                                  Icons.category_outlined,
                                  size: 28,
                                  color: colorScheme.primary,
                                );
                              },
                            )
                          : Icon(
                              Icons.category_outlined,
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                place.placeName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.semiBold16.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            StatusBadge(status: status, color: statusColor),
                          ],
                        ),

                        const SizedBox(height: 6),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: colorScheme.primary.withValues(
                                alpha: 0.15,
                              ),
                            ),
                          ),
                          child: Text(
                            categoryName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.regular11.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ============================================================
              // ADDRESS
              // ============================================================
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 17,
                      color: colorScheme.primary,
                    ),

                    const SizedBox(width: 7),

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

                    Material(
                      color: colorScheme.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(9),
                      child: InkWell(
                        onTap: () => openLocation(context, place),
                        borderRadius: BorderRadius.circular(9),
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: Icon(
                            Icons.navigation_rounded,
                            size: 18,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ============================================================
              // PHONE
              // ============================================================
              if (hasPhoneNumber) ...[
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 17,
                        color: colorScheme.primary,
                      ),

                      const SizedBox(width: 7),

                      Expanded(
                        child: Text(
                          place.phoneNumber!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.regular11.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Material(
                        color: colorScheme.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(9),
                        child: InkWell(
                          onTap: () =>
                              makePhoneCall(context, place.phoneNumber!),
                          borderRadius: BorderRadius.circular(9),
                          child: Padding(
                            padding: const EdgeInsets.all(7),
                            child: Icon(
                              Icons.call_rounded,
                              size: 18,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // ============================================================
              // ACTIONS
              // ============================================================
              Row(
                children: [
                  Expanded(
                    child: PlaceActionButton(
                      icon: Icons.edit_outlined,
                      label: 'تعديل',
                      color: colorScheme.primary,
                      onTap: onEdit,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: PlaceActionButton(
                      icon: Icons.delete_outline_rounded,
                      label: 'حذف',
                      color: colorScheme.error,
                      onTap: onDelete,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
