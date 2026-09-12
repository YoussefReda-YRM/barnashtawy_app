import 'package:barnasht_app/core/helper_functions/open_location.dart';
import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:barnasht_app/features/places/domain/entities/place_entity.dart';
import 'package:barnasht_app/features/profile/presentation/views/widgets/place_action_buston.dart';
import 'package:barnasht_app/features/profile/presentation/views/widgets/status_badge_widget.dart';
import 'package:flutter/material.dart';

class MyPlaceCard extends StatelessWidget {
  const MyPlaceCard({
    super.key,
    required this.place,
    required this.status,
    required this.statusColor,
    required this.onEdit,
    required this.onDelete,
  });

  final PlaceEntity place;
  final String status;
  final Color statusColor;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.25),
            width: 1.1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.05),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.storefront_outlined,
                      color: colorScheme.primary,
                      size: 27,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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

                        Row(
                          children: [
                            Icon(
                              Icons.category_outlined,
                              size: 14,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.50,
                              ),
                            ),

                            const SizedBox(width: 5),

                            Expanded(
                              child: Text(
                                place.categoryId,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.regular11.copyWith(
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.55,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

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

              const SizedBox(height: 12),

              // ========================================================
              // ACTIONS
              // ========================================================
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
