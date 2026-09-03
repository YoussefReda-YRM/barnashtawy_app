import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:barnasht_app/core/widgets/custom_button_widget.dart';
import 'package:barnasht_app/core/widgets/custom_header_icon_widget.dart';
import 'package:barnasht_app/core/widgets/custom_logo_widget.dart';
import 'package:barnasht_app/features/add_place/presentation/views/widgets/open_location.dart';
import 'package:barnasht_app/features/places/domain/entities/place_entity.dart';
import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

class DetailsPlaceView extends StatelessWidget {
  const DetailsPlaceView({
    super.key,
    required this.place,
    required this.placeImage,
  });

  static const routeName = 'details-place-view';

  final PlaceEntity place;
  final String placeImage;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo
                    const CustomLogoWidget(),

                    // Category Name
                    Expanded(
                      child: Text(
                        'تفاصيل المكان',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyles.bold16.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),

                    CustomHeaderIconWidget(
                      widget: Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 22,
                        color: colorScheme.primary,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ==========================================================
                      // PLACE HEADER
                      // ==========================================================

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: colorScheme.primary.withValues(
                              alpha: 0.20,
                            ),
                            width: 1.1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withValues(
                                alpha: 0.06,
                              ),
                              blurRadius: 18,
                              spreadRadius: 1,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // ======================================================
                            // ICON
                            // ======================================================

                            Container(
                              width: 120,
                              height: 120,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: SvgPicture.asset(placeImage),
                            ),

                            const SizedBox(height: 8),

                            // ======================================================
                            // NAME
                            // ======================================================

                            Text(
                              place.placeName,
                              textAlign: TextAlign.center,
                              style: TextStyles.bold16.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // ======================================================
                            // DESCRIPTION
                            // ======================================================

                            Text(
                              place.placeDescription,
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

                      const SizedBox(height: 20),

                      // ==========================================================
                      // INFORMATION TITLE
                      // ==========================================================

                      Text(
                        'معلومات المكان',
                        style: TextStyles.semiBold16.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ==========================================================
                      // ADDRESS
                      // ==========================================================

                      _InfoCard(
                        icon: Icons.location_on_outlined,
                        title: 'العنوان',
                        value: place.placeAddress,
                      ),

                      const SizedBox(height: 10),

                      // ==========================================================
                      // LOCATION
                      // ==========================================================

                      _InfoCard(
                        icon: Icons.my_location_rounded,
                        title: 'الموقع',
                        value:
                            '${place.longitude.toString()}, ${place.latitude.toString()}',
                      ),

                      const SizedBox(height: 20),

                      // ==========================================================
                      // LOCATION BUTTON
                      // ==========================================================

                      CustomButtonWidget(
                        text: 'الوصول للمكان',
                        icon: Icons.navigation_rounded,
                        onTap: () => openLocation(context, place),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// INFO CARD
// ============================================================================

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.09),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: colorScheme.primary,
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.regular11.copyWith(
                    color: colorScheme.onSurface.withValues(
                      alpha: 0.60,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.semiBold13.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}