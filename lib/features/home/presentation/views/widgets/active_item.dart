
import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class ActiveItem extends StatelessWidget {
  const ActiveItem({
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
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              image,
              width: 23,
              height: 23,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 4),
            Text(
              text,
              style: TextStyles.semiBold11.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

