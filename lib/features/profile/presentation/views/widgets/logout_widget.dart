import 'package:barnasht_app/core/services/firebase_auth_service.dart';
import 'package:barnasht_app/core/services/get_it_service.dart';
import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:barnasht_app/core/widgets/build_bar.dart';
import 'package:barnasht_app/core/widgets/show_custom_app_dialog.dart';
import 'package:barnasht_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:barnasht_app/features/profile/presentation/cubits/profile_state.dart';
import 'package:barnasht_app/features/profile/presentation/views/widgets/delete_account_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({
    super.key,
    required this.colorScheme,
    required this.onLoggedOut,
  });

  final ColorScheme colorScheme;
  final VoidCallback onLoggedOut;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildLogoutButton(context),
        const SizedBox(height: 10),
        _buildDeleteAccountButton(context),
      ],
    );
  }

  Widget _buildDeleteAccountButton(BuildContext context) {
    return Material(
      color: colorScheme.error.withValues(alpha: 0.07),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => _showDeleteAccountDialog(context),
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
                  Icons.delete_forever_rounded,
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
                      'حذف الحساب نهائيًا',
                      style: TextStyles.semiBold13.copyWith(
                        color: colorScheme.error,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      'حذف حسابك وبياناتك والأماكن التي أضفتها نهائيًا',
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

  Widget _buildLogoutButton(BuildContext context) {
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
              await getIt<FirebaseAuthService>().signOut();

              if (!context.mounted) {
                return;
              }

              onLoggedOut();

              if (!context.mounted) {
                return;
              }

              buildBar(
                context,
                'تم تسجيل الخروج بنجاح',
                type: SnackBarType.success,
              );
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
                      'الخروج من حسابك على رفيق',
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

  void _showDeleteAccountDialog(BuildContext context) {
    final currentUser = getIt<FirebaseAuthService>().currentUser;

    if (currentUser == null) {
      buildBar(context, 'يجب تسجيل الدخول أولاً.', type: SnackBarType.error);
      return;
    }

    final requiresPassword = currentUser.providerData.any(
      (provider) => provider.providerId == 'password',
    );

    // نحتفظ بنفس ProfileCubit الموجود في ProfileView.
    final profileCubit = context.read<ProfileCubit>();

    // Key للوصول إلى State الخاص بالـDialog.
    final dialogKey = GlobalKey<DeleteAccountDialogState>();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: profileCubit,
          child: BlocListener<ProfileCubit, ProfileState>(
            listener: (listenerContext, state) {
              if (state is ProfileDeleteFailure) {
                dialogKey.currentState?.showError(state.message);
              }
            },
            child: DeleteAccountDialog(
              key: dialogKey,
              requiresPassword: requiresPassword,
              colorScheme: colorScheme,
              onConfirm: (password) async {
                final success = await profileCubit.deleteAccount(
                  password: password,
                );

                if (!success) {
                  return false;
                }

                // الحذف نجح بالكامل.
                if (!context.mounted) {
                  return true;
                }

                onLoggedOut();

                if (!context.mounted) {
                  return true;
                }

                buildBar(
                  context,
                  'تم حذف الحساب نهائيًا.',
                  type: SnackBarType.success,
                );

                return true;
              },
            ),
          ),
        );
      },
    );
  }
}
