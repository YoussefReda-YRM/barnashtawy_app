import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(child: Divider(color: colorScheme.outlineVariant)),
        SizedBox(width: 18),
        Text(
          'أو',
          textAlign: TextAlign.center,
          style: TextStyles.semiBold16.copyWith(color: colorScheme.onSurface),
        ),
        SizedBox(width: 18),
        Expanded(child: Divider(color: colorScheme.outlineVariant)),
      ],
    );
  }
}
