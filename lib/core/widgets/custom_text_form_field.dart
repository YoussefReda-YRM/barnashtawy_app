import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const new({
    super.key,
    this.controller,
    required this.validator,
    required this.maxLines,
    required this.keyboardType,
    required this.colorScheme,
    required this.hint,
    this.suffixIcon,
    this.onSaved,

    this.obscureText = false,
  });

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextInputType? keyboardType;
  final ColorScheme colorScheme;
  final String hint;
  final bool obscureText;
  final Widget? suffixIcon;
  final void Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,

      controller: controller,
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboardType,

      textInputAction: maxLines > 1
          ? TextInputAction.newline
          : TextInputAction.next,

      style: TextStyles.regular13.copyWith(color: colorScheme.onSurface),

      decoration: InputDecoration(
        suffixIcon: suffixIcon,

        hintText: hint,

        hintStyle: TextStyles.regular13.copyWith(
          color: colorScheme.onSurface.withValues(alpha: 0.50),
        ),

        filled: true,

        fillColor: colorScheme.surface,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),

        border: _buildInputBorder(colorScheme),

        enabledBorder: _buildInputBorder(colorScheme),

        focusedBorder: _buildFocusedBorder(colorScheme),

        errorBorder: _buildErrorBorder(colorScheme),

        focusedErrorBorder: _buildFocusedErrorBorder(colorScheme),
      ),
    );
  }

  // ============================================================
  // DEFAULT BORDER
  // ============================================================

  OutlineInputBorder _buildInputBorder(ColorScheme colorScheme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        width: 1,
        color: colorScheme.primary.withValues(alpha: 0.20),
      ),
    );
  }

  // ============================================================
  // FOCUSED BORDER
  // ============================================================

  OutlineInputBorder _buildFocusedBorder(ColorScheme colorScheme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        width: 1.3,
        color: colorScheme.primary.withValues(alpha: 0.65),
      ),
    );
  }

  // ============================================================
  // ERROR BORDER
  // ============================================================

  OutlineInputBorder _buildErrorBorder(ColorScheme colorScheme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        width: 1,
        color: colorScheme.error.withValues(alpha: 0.60),
      ),
    );
  }

  // ============================================================
  // FOCUSED ERROR BORDER
  // ============================================================

  OutlineInputBorder _buildFocusedErrorBorder(ColorScheme colorScheme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(width: 1.3, color: colorScheme.error),
    );
  }
}
