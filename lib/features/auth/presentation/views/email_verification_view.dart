import 'package:barnasht_app/core/services/get_it_service.dart';
import 'package:barnasht_app/core/utils/app_images.dart';
import 'package:barnasht_app/core/widgets/build_bar.dart';
import 'package:barnasht_app/core/widgets/custom_app_bar.dart';
import 'package:barnasht_app/core/widgets/custom_button_widget.dart';
import 'package:barnasht_app/features/auth/presentation/cubits/email_verification_cubit/email_verification_cubit.dart';
import 'package:barnasht_app/features/auth/presentation/views/signin_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailVerificationView extends StatelessWidget {
  const EmailVerificationView({super.key});

  static const routeName = 'email-verification';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EmailVerificationCubit>(),
      child: const EmailVerificationViewBody(),
    );
  }
}

class EmailVerificationViewBody extends StatelessWidget {
  const EmailVerificationViewBody({super.key});

  Future<void> _openEmailApp(BuildContext context) async {
    final gmailUri = Uri.parse('https://mail.google.com/mail/u/0/#inbox');

    final launched = await launchUrl(
      gmailUri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && context.mounted) {
      buildBar(
        context,
        'لم نتمكن من فتح البريد الإلكتروني.',
        type: SnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? '';

    return BlocConsumer<EmailVerificationCubit, EmailVerificationState>(
      listener: (context, state) {
        if (state is EmailVerificationSuccess) {
          Navigator.pushReplacementNamed(
            context,
            SigninView.routeName,
            arguments: true,
          );
          buildBar(
            context,
            'تم تأكيد البريد الإلكتروني بنجاح، يمكنك تسجيل الدخول الآن.',
            type: SnackBarType.success,
          );
        }

        if (state is EmailVerificationNotVerified) {
          buildBar(
            context,
            'لم يتم تأكيد البريد الإلكتروني بعد.',
            type: SnackBarType.warning,
          );
        }

        if (state is EmailVerificationResendSuccess) {
          buildBar(
            context,
            'تم إعادة إرسال رابط تأكيد البريد الإلكتروني.',
            type: SnackBarType.success,
          );
        }

        if (state is EmailVerificationFailure) {
          buildBar(context, state.message, type: SnackBarType.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  customAppBar(context, title: 'تأكيد البريد الإلكتروني'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Image.asset(
                          Assets.imagesAppLogoTransparent,
                          width: 180,
                          height: 180,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'تأكيد البريد الإلكتروني',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'تم إرسال رابط تأكيد إلى:',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          email,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'افتح بريدك الإلكتروني واضغط على رابط التأكيد لتفعيل حسابك.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 40),
                        CustomButtonWidget(
                          onTap: state is EmailVerificationLoading
                              ? null
                              : () {
                                  context
                                      .read<EmailVerificationCubit>()
                                      .checkEmailVerification();
                                },
                          text: 'لقد أكدت البريد',
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () => _openEmailApp(context),
                          icon: const Icon(Icons.email_outlined),
                          label: const Text('فتح Gmail'),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: state is EmailVerificationLoading
                              ? null
                              : () {
                                  context
                                      .read<EmailVerificationCubit>()
                                      .resendVerificationEmail();
                                },
                          child: const Text('إعادة إرسال رابط التأكيد'),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
