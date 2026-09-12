import 'package:barnasht_app/core/utils/app_colors.dart';
import 'package:barnasht_app/core/widgets/custom_header_icon_widget.dart';
import 'package:barnasht_app/core/widgets/custom_logo_widget.dart';
import 'package:flutter/material.dart';

import '../utils/app_text_styles.dart';

Widget customAppBar(
  BuildContext context, {
  required String title,
  bool showBackButton = true,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  return Padding(
    padding: const EdgeInsets.only(left: 16),
    child: Row(
      children: [
        // Logo
        const CustomLogoWidget(),

        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyles.bold16.copyWith(color: colorScheme.onSurface),
          ),
        ),

        Visibility(
          visible: showBackButton,
          child: CustomHeaderIconWidget(
            widget: Icon(
              Icons.arrow_forward_ios_outlined,
              size: 22,
              color: AppColors.primary,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    ),
  );
}
