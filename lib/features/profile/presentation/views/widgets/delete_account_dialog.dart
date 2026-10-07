import 'package:flutter/material.dart';

import 'package:barnasht_app/core/utils/app_text_styles.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({
    super.key,
    required this.onConfirm,
    required this.requiresPassword,
    this.colorScheme,
  });

  final Future<bool> Function(String? password) onConfirm;
  final bool requiresPassword;
  final ColorScheme? colorScheme;

  @override
  DeleteAccountDialogState createState() => DeleteAccountDialogState();
}

class DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirm() async {
    if (widget.requiresPassword && _passwordController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'أدخل كلمة السر الحالية للمتابعة.';
      });
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await widget.onConfirm(
      widget.requiresPassword ? _passwordController.text : null,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      Navigator.of(context).pop();
      return;
    }

    // في حالة الفشل، BlocListener يكون قد وضع رسالة الخطأ
    // داخل الـDialog من خلال showError().
    setState(() {
      _isLoading = false;
    });
  }

  void showError(String message) {
    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
      _errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = widget.colorScheme ?? Theme.of(context).colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),

      title: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colorScheme.error.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.delete_forever_rounded, color: colorScheme.error),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text('حذف الحساب', style: TextStyles.semiBold16)),
        ],
      ),

      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'هل أنت متأكد أنك تريد حذف حسابك نهائيًا؟',
              style: TextStyles.semiBold13,
            ),

            const SizedBox(height: 8),

            Text(
              'سيتم حذف حسابك وبياناتك والأماكن التي أضفتها، ولا يمكن التراجع عن هذا الإجراء.',
              style: TextStyles.regular11.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.65),
                height: 1.5,
              ),
            ),

            if (widget.requiresPassword) ...[
              const SizedBox(height: 20),

              Text(
                'أدخل كلمة السر الحالية للتأكيد:',
                style: TextStyles.semiBold13,
              ),

              const SizedBox(height: 8),

              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                enabled: !_isLoading,
                textDirection: TextDirection.ltr,
                onChanged: (_) {
                  if (_errorMessage != null) {
                    setState(() {
                      _errorMessage = null;
                    });
                  }
                },
                decoration: InputDecoration(
                  hintText: 'كلمة السر',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                  errorText: _errorMessage,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ] else if (_errorMessage != null) ...[
              const SizedBox(height: 16),

              Text(
                _errorMessage!,
                style: TextStyles.regular11.copyWith(color: colorScheme.error),
              ),
            ],
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: _isLoading
              ? null
              : () {
                  Navigator.of(context).pop();
                },
          child: const Text('إلغاء'),
        ),

        FilledButton(
          onPressed: _isLoading ? null : _handleConfirm,
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.error,
            foregroundColor: colorScheme.onError,
          ),
          child: _isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.onError,
                  ),
                )
              : const Text('حذف الحساب'),
        ),
      ],
    );
  }
}
