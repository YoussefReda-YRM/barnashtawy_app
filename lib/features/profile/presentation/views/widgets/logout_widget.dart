import 'package:barnasht_app/core/services/firebase_auth_service.dart';
import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:barnasht_app/core/widgets/build_bar.dart';
import 'package:barnasht_app/core/widgets/show_custom_app_dialog.dart';
import 'package:flutter/material.dart';

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({super.key, required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colorScheme.error.withValues(alpha: 0.07),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          showCustomAppDialog(
            context: context,
            title: 'تسجيل الخروج',
            message: 'هل أنت متأكد أنك تريد تسجيل الخروج من حسابك؟',
            icon: Icons.logout_rounded,
            iconColor: colorScheme.error,
            confirmButtonColor: colorScheme.error,
            confirmText: 'تسجيل الخروج',
            onConfirm: () async {
              await FirebaseAuthService().signOut();
              if (context.mounted) {
                Navigator.pop(context);
              }

              if (context.mounted) {
                buildBar(
                  context,
                  'تم تسجيل الخروج بنجاح',
                  type: SnackBarType.success,
                );
              }
            },
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.error.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_rounded,
                  size: 20,
                  color: colorScheme.error,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تسجيل الخروج',
                      style: TextStyles.semiBold13.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'الخروج من حسابك على برنشتاوي',
                      style: TextStyles.regular11.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.50),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: colorScheme.error.withValues(alpha: 0.60),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
