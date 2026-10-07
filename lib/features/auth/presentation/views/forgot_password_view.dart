import 'package:barnasht_app/core/utils/app_images.dart';
import 'package:barnasht_app/core/widgets/build_bar.dart';
import 'package:barnasht_app/core/widgets/custom_app_bar.dart';
import 'package:barnasht_app/core/widgets/custom_button_widget.dart';
import 'package:barnasht_app/core/widgets/custom_text_form_field.dart';
import 'package:barnasht_app/features/auth/presentation/cubits/forgot_password_cubit/forgot_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  static const routeName = '/forgot-password';

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void sendPasswordResetEmail() {
    if (formKey.currentState!.validate()) {
      context.read<ForgotPasswordCubit>().sendPasswordResetEmail(
            emailController.text.trim(),
          );
    } else {
      setState(() {
        autovalidateMode = AutovalidateMode.always;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            buildBar(
              context,
              'تم إرسال رابط إعادة تعيين كلمة السر إلى بريدك الإلكتروني.',
              type: SnackBarType.success,
            );
          }

          if (state is ForgotPasswordFailure) {
            buildBar(
              context,
              state.message,
              type: SnackBarType.error,
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: ModalProgressHUD(
              inAsyncCall: state is ForgotPasswordLoading,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  autovalidateMode: autovalidateMode,
                  child: Column(
                    children: [
                      customAppBar(
                        context,
                        title: 'نسيت كلمة السر',
                      ),
            
                      const SizedBox(height: 30),
            
                      Image.asset(
                        Assets.imagesAppLogoTransparent,
                        width: 180,
                        height: 180,
                      ),
            
                      const SizedBox(height: 30),
            
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'إعادة تعيين كلمة السر',
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
            
                            const SizedBox(height: 12),
            
                            Text(
                              'أدخل البريد الإلكتروني المرتبط بحسابك، '
                              'وسنرسل لك رابطًا لإعادة تعيين كلمة السر.',
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
            
                            const SizedBox(height: 30),
            
                            CustomTextFormField(
                              colorScheme: colorScheme,
                              controller: emailController,
                              maxLines: 1,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty) {
                                  return 'ادخل البريد الإلكتروني';
                                }
            
                                final emailRegex = RegExp(
                                  r'^[\w\.-]+@[\w\.-]+\.\w+$',
                                );
            
                                if (!emailRegex.hasMatch(value.trim())) {
                                  return 'ادخل بريد إلكتروني صحيح';
                                }
            
                                return null;
                              },
                              hint: 'البريد الإلكتروني',
                              keyboardType:
                                  TextInputType.emailAddress,
                            ),
            
                            const SizedBox(height: 30),
            
                            CustomButtonWidget(
                              onTap: sendPasswordResetEmail,
                              text: 'إرسال رابط إعادة التعيين',
                            ),
            
                            const SizedBox(height: 20),
            
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'العودة لتسجيل الدخول',
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}