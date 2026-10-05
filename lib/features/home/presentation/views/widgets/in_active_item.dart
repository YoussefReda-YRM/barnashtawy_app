
import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class InactiveItem extends StatelessWidget {
  const InactiveItem({
    super.key,
    required this.text,
    required this.image,
  });

  final String text;
  final String image;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
            opacity: 0.55,
            child: Image.asset(
              image,
              width: 23,
              height: 23,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: TextStyles.semiBold11.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.50),
            ),
          ),
        ],
      ),
    );
  }
}
