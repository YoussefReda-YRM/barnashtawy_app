import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.image,
    required this.title,
    required this.onPressed,
  });

  final String image;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: colorScheme.outlineVariant, width: 1),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onPressed,
        child: ListTile(
          visualDensity: const VisualDensity(
            vertical: VisualDensity.minimumDensity,
          ),
          leading: SvgPicture.asset(image),
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyles.semiBold13.copyWith(color: colorScheme.onSurface),
          ),
        ),
      ),
    );
  }
}
