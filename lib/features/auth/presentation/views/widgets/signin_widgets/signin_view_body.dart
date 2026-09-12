import 'package:barnasht_app/core/utils/app_images.dart';
import 'package:barnasht_app/core/widgets/custom_app_bar.dart';
import 'package:barnasht_app/core/widgets/custom_button_widget.dart';
import 'package:barnasht_app/core/widgets/custom_text_form_field.dart';
import 'package:barnasht_app/core/widgets/password_field.dart';
import 'package:barnasht_app/features/auth/presentation/cubits/signin_cubit/signin_cubit.dart';
import 'package:barnasht_app/features/auth/presentation/views/widgets/or_divider.dart';
import 'package:barnasht_app/features/auth/presentation/views/widgets/signin_widgets/dont_have_an_account_widget.dart';
import 'package:barnasht_app/features/auth/presentation/views/widgets/social_signin_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninViewBody extends StatefulWidget {
  const SigninViewBody({super.key});

  @override
  State<SigninViewBody> createState() => _SigninViewBodyState();
}

class _SigninViewBodyState extends State<SigninViewBody> {
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signin() {
    if (formKey.currentState!.validate()) {
      context.read<SigninCubit>().signin(
        emailController.text.trim(),
        passwordController.text,
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

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        autovalidateMode: autovalidateMode,
        child: Column(
          children: [
            customAppBar(context, title: 'تسجيل دخول'),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Image.asset(
                    Assets.imagesAppLogoTransparent,
                    width: 200,
                    height: 200,
                  ),

                  const SizedBox(height: 16),

                  CustomTextFormField(
                    controller: emailController,
                    colorScheme: colorScheme,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'أدخل البريد الالكتروني';
                      }

                      return null;
                    },
                    maxLines: 1,
                    hint: 'البريد الالكتروني',
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16),

                  PasswordField(controller: passwordController),

                  const SizedBox(height: 33),

                  CustomButtonWidget(onTap: signin, text: 'تسجيل دخول'),

                  const SizedBox(height: 33),

                  const DontHaveAnAccountWidget(),

                  const SizedBox(height: 24),

                  const OrDivider(),

                  const SizedBox(height: 16),

                  SocialLoginButton(
                    onPressed: () {
                      context.read<SigninCubit>().signinWithGoogle();
                    },
                    image: Assets.imagesGoogleIcon,
                    title: 'تسجيل بواسطة جوجل',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
