import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    this.validator,
    required this.maxLines,
    this.minLines = 1,
    this.keyboardType,
    required this.colorScheme,
    required this.hint,
    this.suffixIcon,
    this.onSaved,
    this.onChanged,
    this.obscureText = false,
    this.readOnly = false,
    this.textInputAction,
  });

  final TextEditingController? controller;

  final String? Function(String?)? validator;

  final int maxLines;
  final int minLines;

  final TextInputType? keyboardType;

  final ColorScheme colorScheme;

  final String hint;

  final bool obscureText;
  final bool readOnly;

  final Widget? suffixIcon;

  final void Function(String?)? onSaved;

  final void Function(String)? onChanged;

  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,

      readOnly: readOnly,
      obscureText: obscureText,

      minLines: minLines,
      maxLines: maxLines,

      keyboardType: keyboardType,

      textInputAction:
          textInputAction ??
          (maxLines > 1
              ? TextInputAction.newline
              : TextInputAction.next),

      style: TextStyles.regular13.copyWith(
        color: colorScheme.onSurface,
      ),

      decoration: InputDecoration(
        suffixIcon: suffixIcon,

        hintText: hint,

        hintStyle: TextStyles.regular11.copyWith(
          color: colorScheme.onSurface.withValues(
            alpha: 0.50,
          ),
        ),

        filled: true,

        fillColor: colorScheme.surface,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),

        border: _buildInputBorder(),

        enabledBorder: _buildInputBorder(),

        focusedBorder: _buildFocusedBorder(),

        errorBorder: _buildErrorBorder(),

        focusedErrorBorder: _buildFocusedErrorBorder(),
      ),
    );
  }

  OutlineInputBorder _buildInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        width: 1,
        color: colorScheme.primary.withValues(
          alpha: 0.20,
        ),
      ),
    );
  }

  OutlineInputBorder _buildFocusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        width: 1.3,
        color: colorScheme.primary.withValues(
          alpha: 0.65,
        ),
      ),
    );
  }

  OutlineInputBorder _buildErrorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        width: 1,
        color: colorScheme.error.withValues(
          alpha: 0.60,
        ),
      ),
    );
  }

  OutlineInputBorder _buildFocusedErrorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        width: 1.3,
        color: colorScheme.error,
      ),
    );
  }
}