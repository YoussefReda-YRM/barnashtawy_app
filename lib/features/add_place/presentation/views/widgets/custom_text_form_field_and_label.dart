import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:barnasht_app/core/widgets/custom_text_form_field.dart';
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
        CustomTextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          keyboardType: keyboardType,
          colorScheme: colorScheme,
          hint: hint,
        ),
      ],
    );
  }
}
