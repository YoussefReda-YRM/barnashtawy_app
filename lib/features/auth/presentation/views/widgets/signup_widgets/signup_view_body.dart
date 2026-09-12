import 'package:barnasht_app/core/utils/app_images.dart';
import 'package:barnasht_app/core/widgets/build_bar.dart';
import 'package:barnasht_app/core/widgets/custom_app_bar.dart';
import 'package:barnasht_app/core/widgets/custom_button_widget.dart';
import 'package:barnasht_app/core/widgets/custom_text_form_field.dart';
import 'package:barnasht_app/core/widgets/password_field.dart';
import 'package:barnasht_app/features/auth/presentation/cubits/signup_cubit/signup_cubit.dart';
import 'package:barnasht_app/features/auth/presentation/views/widgets/signup_widgets/have_an_acount_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupViewBody extends StatefulWidget {
  const SignupViewBody({super.key});

  @override
  State<SignupViewBody> createState() => _SignupViewBodyState();
}

class _SignupViewBodyState extends State<SignupViewBody> {
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isTermsAccepted = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signup() {
    if (formKey.currentState!.validate()) {
      if (!isTermsAccepted) {
        buildBar(
          context,
          'يجب عليك الموافقة على الشروط والأحكام',
          type: SnackBarType.warning,
        );
        return;
      }

      context.read<SignupCubit>().createUserWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text,
        nameController.text.trim(),
        phoneController.text.trim(),
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
            customAppBar(context, title: 'إنشاء حساب جديد'),

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

                  // Name
                  CustomTextFormField(
                    controller: nameController,
                    colorScheme: colorScheme,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'ادخل الاسم كامل';
                      }

                      return null;
                    },
                    maxLines: 1,
                    hint: 'الاسم كامل',
                    keyboardType: TextInputType.name,
                  ),

                  const SizedBox(height: 16),

                  // Phone Number
                  CustomTextFormField(
                    controller: phoneController,
                    colorScheme: colorScheme,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'ادخل رقم الموبايل';
                      }

                      if (value.trim().length < 11) {
                        return 'ادخل رقم موبايل صحيح';
                      }

                      return null;
                    },
                    maxLines: 1,
                    hint: 'رقم الموبايل',
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 16),

                  // Email
                  CustomTextFormField(
                    controller: emailController,
                    colorScheme: colorScheme,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'ادخل البريد الإلكتروني';
                      }

                      return null;
                    },
                    maxLines: 1,
                    hint: 'البريد الإلكتروني',
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16),

                  // Password
                  PasswordField(controller: passwordController),

                  // // Terms and Conditions
                  // TermsAndConditionsWidget(
                  //   onChanged: (value) {
                  //     setState(() {
                  //       isTermsAccepted = value;
                  //     });
                  //   },
                  // ),
                  const SizedBox(height: 33),

                  // Signup Button
                  CustomButtonWidget(onTap: signup, text: 'إنشاء حساب جديد'),

                  const SizedBox(height: 33),

                  const HaveAnAccountWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
