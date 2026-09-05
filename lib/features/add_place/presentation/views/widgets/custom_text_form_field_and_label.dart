import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomTextFormFieldAndLabel extends StatelessWidget {
  const CustomTextFormFieldAndLabel({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
    this.validator,
    this.keyboardType,
    this.isRequired = true,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ============================================================
        // LABEL
        // ============================================================

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Text(
                label,
                style: TextStyles.semiBold13.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 4),
              isRequired
                  ? Text(
                      '*',
                      style: TextStyles.semiBold13.copyWith(color: Colors.red),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),

        const SizedBox(height: 7),

        // ============================================================
        // TEXT FORM FIELD
        // ============================================================
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          keyboardType: keyboardType,

          textInputAction: maxLines > 1
              ? TextInputAction.newline
              : TextInputAction.next,

          style: TextStyles.regular13.copyWith(color: colorScheme.onSurface),

          decoration: InputDecoration(
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
        ),
      ],
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
