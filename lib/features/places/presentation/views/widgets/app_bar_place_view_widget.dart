import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:barnasht_app/core/widgets/custom_header_icon_widget.dart';
import 'package:barnasht_app/core/widgets/custom_logo_widget.dart';
import 'package:barnasht_app/features/add_place/presentation/views/add_place_view.dart';
import 'package:barnasht_app/features/home/domain/entities/category_entities.dart';
import 'package:flutter/material.dart';

class AppBarPlaceViewWidget extends StatelessWidget {
  const AppBarPlaceViewWidget({
    super.key,
    required this.category,
  });

  final CategoryEntity category;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        // Logo
        const CustomLogoWidget(),

        // Category Name
        Expanded(
          child: Text(
            category.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyles.bold16.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ),

        // Add Button + Back Button
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add Place
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AddPlaceView.routeName,
                    arguments: category,
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_rounded,
                        size: 19,
                        color: colorScheme.onPrimary,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        'طلب إضافة مكان',
                        style: TextStyles.bold11.copyWith(
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Back Button
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
      ],
    );
  }
}