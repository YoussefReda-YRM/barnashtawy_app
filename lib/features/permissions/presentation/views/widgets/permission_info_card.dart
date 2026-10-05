import 'package:barnasht_app/features/permissions/presentation/views/widgets/permission_page_type.dart';
import 'package:flutter/material.dart';

class PermissionInfoCard extends StatelessWidget {
  const PermissionInfoCard({
    super.key,
    required this.type,
  });

  final PermissionPageType type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isLocation = type == PermissionPageType.location;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.55,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(
            alpha: 0.35,
          ),
        ),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(
                alpha: 0.12,
              ),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              isLocation
                  ? Icons.privacy_tip_outlined
                  : Icons.notifications_none_rounded,
              size: 22,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Text(
              isLocation
                  ? 'لن نستخدم موقعك إلا لتقديم تجربة أفضل للأماكن القريبة منك.'
                  : 'يمكنك تغيير إعدادات الإشعارات في أي وقت من إعدادات هاتفك.',
              textAlign: TextAlign.right,
              style: theme.textTheme.bodySmall?.copyWith(
                height: 1.55,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}