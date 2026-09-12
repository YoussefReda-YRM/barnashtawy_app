import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

Future<T?> showCustomAppDialog<T>({
  required BuildContext context,
  required String title,
  required String message,
  required IconData icon,
  required String confirmText,
  required Future<void> Function() onConfirm,
  Color? iconColor,
  Color? confirmButtonColor,
  String cancelText = 'إلغاء',
  bool showCancelButton = true,
}) {
  final colorScheme = Theme.of(context).colorScheme;

  final resolvedIconColor = iconColor ?? colorScheme.primary;
  final resolvedConfirmColor =
      confirmButtonColor ?? colorScheme.primary;

  return showDialog<T>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return _CustomAppDialog(
        title: title,
        message: message,
        icon: icon,
        iconColor: resolvedIconColor,
        confirmButtonColor: resolvedConfirmColor,
        confirmText: confirmText,
        cancelText: cancelText,
        showCancelButton: showCancelButton,
        onConfirm: onConfirm,
      );
    },
  );
}

class _CustomAppDialog extends StatefulWidget {
  const _CustomAppDialog({
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.confirmButtonColor,
    required this.confirmText,
    required this.cancelText,
    required this.showCancelButton,
    required this.onConfirm,
  });

  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final Color confirmButtonColor;
  final String confirmText;
  final String cancelText;
  final bool showCancelButton;
  final Future<void> Function() onConfirm;

  @override
  State<_CustomAppDialog> createState() => _CustomAppDialogState();
}

class _CustomAppDialogState extends State<_CustomAppDialog> {
  bool isLoading = false;

  Future<void> confirm() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      await widget.onConfirm();

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ، يرجى المحاولة مرة أخرى'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        contentPadding: const EdgeInsets.fromLTRB(
          24,
          20,
          24,
          12,
        ),
        titlePadding: const EdgeInsets.fromLTRB(
          24,
          24,
          24,
          8,
        ),
        title: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: widget.iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                size: 32,
                color: widget.iconColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyles.bold16.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        content: Text(
          widget.message,
          textAlign: TextAlign.center,
          style: TextStyles.regular13.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.6,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          20,
          8,
          20,
          20,
        ),
        actions: [
          Row(
            children: [
              if (widget.showCancelButton) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: isLoading
                        ? null
                        : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      side: BorderSide(
                        color: colorScheme.outline,
                      ),
                    ),
                    child: Text(
                      widget.cancelText,
                      style: TextStyles.bold13.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                flex: widget.showCancelButton ? 2 : 1,
                child: ElevatedButton(
                  onPressed: isLoading ? null : confirm,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: widget.confirmButtonColor,
                    foregroundColor: colorScheme.onPrimary,
                    disabledBackgroundColor:
                        widget.confirmButtonColor.withValues(alpha: 0.6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.onPrimary,
                          ),
                        )
                      : Text(
                          widget.confirmText,
                          style: TextStyles.bold13.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}