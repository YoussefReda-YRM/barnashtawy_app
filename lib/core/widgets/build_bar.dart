import 'package:flutter/material.dart';

enum SnackBarType { success, error, warning, info }

void buildBar(
  BuildContext context,
  String message, {
  SnackBarType type = SnackBarType.info,
  String? title,
  Duration duration = const Duration(seconds: 2),
}) {
  final config = _getSnackBarConfig(type);

  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    elevation: 0,
    duration: duration,
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
    padding: EdgeInsets.zero,
    content: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: config.iconColor.withValues(alpha: .15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: config.iconColor.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: Icon(config.icon, color: config.iconColor, size: 22),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ?? config.defaultTitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  message,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Colors.white.withValues(alpha: .82),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.close_rounded,
                color: Colors.white.withValues(alpha: .6),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

class _SnackBarConfig {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final String defaultTitle;

  const _SnackBarConfig({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.defaultTitle,
  });
}

_SnackBarConfig _getSnackBarConfig(SnackBarType type) {
  switch (type) {
    case SnackBarType.success:
      return const _SnackBarConfig(
        icon: Icons.check_circle_rounded,
        backgroundColor: Color(0xFF163D2A),
        iconColor: Color(0xFF4ADE80),
        defaultTitle: 'تم بنجاح',
      );

    case SnackBarType.error:
      return const _SnackBarConfig(
        icon: Icons.error_rounded,
        backgroundColor: Color(0xFF421C1C),
        iconColor: Color(0xFFFF6B6B),
        defaultTitle: 'حدث خطأ',
      );

    case SnackBarType.warning:
      return const _SnackBarConfig(
        icon: Icons.warning_rounded,
        backgroundColor: Color(0xFF403316),
        iconColor: Color(0xFFFFC857),
        defaultTitle: 'تنبيه',
      );

    case SnackBarType.info:
      return const _SnackBarConfig(
        icon: Icons.info_rounded,
        backgroundColor: Color(0xFF192F46),
        iconColor: Color(0xFF60A5FA),
        defaultTitle: 'معلومة',
      );
  }
}
