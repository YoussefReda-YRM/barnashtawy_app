import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:barnasht_app/core/widgets/custom_header_icon_widget.dart';
import 'package:barnasht_app/core/widgets/custom_logo_widget.dart';
import 'package:barnasht_app/features/favorite_places/presentation/views/widgets/favorite_place_view_body.dart';
import 'package:flutter/material.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  static const String routeName = 'favorites_view';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              // ==========================================================
              // CUSTOM APP BAR
              // ==========================================================

              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: 8,
                ),
                child: Row(
                  children: [
                    const CustomLogoWidget(),

                    Expanded(
                      child: Text(
                        'المفضلة',
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

              // ==========================================================
              // BODY
              // ==========================================================
              const Expanded(child: FavoritePlaceViewBody()),
            ],
          ),
        ),
      ),
    );
  }
}
