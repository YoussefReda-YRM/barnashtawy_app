import 'package:barnasht_app/core/utils/app_colors.dart';
import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:barnasht_app/core/widgets/custom_logo_widget.dart';
import 'package:barnasht_app/core/widgets/custom_header_icon_widget.dart';
import 'package:flutter/material.dart';

class CustomAppBarAddPlaceWidget extends StatelessWidget {
  const CustomAppBarAddPlaceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          // Logo
          const CustomLogoWidget(),

          Expanded(
            child: Text(
              "طلب إضافة مكان",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyles.bold19.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),

          CustomHeaderIconWidget(
            widget: Icon(
              Icons.arrow_forward_ios_outlined,
              size: 22,
              color: AppColors.primary,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

