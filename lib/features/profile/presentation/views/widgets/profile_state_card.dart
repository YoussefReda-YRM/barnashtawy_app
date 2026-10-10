import 'package:barnasht_app/core/utils/app_colors.dart';
import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class ProfileStatCard extends StatelessWidget {
  const ProfileStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.title,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final cardColor = theme.brightness == Brightness.dark
        ? AppColors.darkCard
        : AppColors.lightSurface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.15), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.16 : 0.05,
            ),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 19, color: color),
          ),

          const SizedBox(height: 8),

          Text(
            value,
            style: TextStyles.bold16.copyWith(color: colorScheme.onSurface),
          ),

          const SizedBox(height: 2),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyles.regular11.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }
}
