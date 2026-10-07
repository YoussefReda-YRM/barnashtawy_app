import 'package:barnasht_app/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    this.controller,
    this.validator,
    required this.hint,
  });

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String hint;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CustomTextFormField(
      colorScheme: colorScheme,
      controller: widget.controller,
      maxLines: 1,
      validator:
          widget.validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'ادخل كلمة السر';
            }

            return null;
          },
      obscureText: obscureText,
      suffixIcon: GestureDetector(
        onTap: () {
          setState(() {
            obscureText = !obscureText;
          });
        },
        child: obscureText
            ? const Icon(Icons.remove_red_eye, color: Color(0xffC9CECF))
            : const Icon(Icons.visibility_off, color: Color(0xffC9CECF)),
      ),
      hint: widget.hint,
      keyboardType: TextInputType.visiblePassword,
    );
  }
}
