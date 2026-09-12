import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:barnasht_app/core/widgets/build_bar.dart';
import 'package:barnasht_app/core/widgets/custom_app_bar.dart';
import 'package:barnasht_app/core/widgets/custom_button_widget.dart';
import 'package:barnasht_app/core/widgets/custom_text_form_field.dart';
import 'package:barnasht_app/features/auth/domain/entities/auth_entity.dart';
import 'package:barnasht_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:barnasht_app/features/profile/presentation/cubits/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key, required this.user});

  static const routeName = 'edit_profile_view';

  final UserEntity user;

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.user.name);

    _phoneController = TextEditingController(text: widget.user.phoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cubit = context.read<ProfileCubit>();

    final updatedUser = UserEntity(
      name: _nameController.text.trim(),
      email: widget.user.email,
      uId: widget.user.uId,
      phoneNumber: _phoneController.text.trim(),
    );

    await cubit.updateProfile(user: updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) {
        return (previous is ProfileUpdating && current is ProfileSuccess) ||
            current is ProfileFailure;
      },
      listener: (context, state) {
        if (state is ProfileSuccess) {
          buildBar(
            context,
            'تم تحديث بياناتك بنجاح',
            type: SnackBarType.success,
          );

          Navigator.pop(context);
        }

        if (state is ProfileFailure) {
          buildBar(
            context,
            "حدث خطاء : ${state.message}",
            type: SnackBarType.error,
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              customAppBar(context, title: "تعديل الملف الشخصي"),

              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        margin: const EdgeInsets.only(bottom: 28),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.primary.withValues(alpha: 0.12),
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.18),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          size: 42,
                          color: colorScheme.primary,
                        ),
                      ),

                      Text(
                        'الاسم',
                        style: TextStyles.semiBold13.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),

                      const SizedBox(height: 8),

                      CustomTextFormField(
                        validator: (value) {
                          final name = value?.trim() ?? '';

                          if (name.isEmpty) {
                            return 'من فضلك أدخل اسمك';
                          }

                          if (name.length < 2) {
                            return 'الاسم يجب أن يكون حرفين على الأقل';
                          }

                          return null;
                        },
                        maxLines: 1,
                        keyboardType: TextInputType.name,
                        colorScheme: colorScheme,
                        hint: 'ادخل اسمك',
                        controller: _nameController,
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'البريد الإلكتروني',
                        style: TextStyles.semiBold13.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),

                      const SizedBox(height: 8),

                      CustomTextFormField(
                        validator: (value) {
                          return null;
                        },
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        colorScheme: colorScheme,
                        hint: 'ادخل بريدك الإلكتروني',
                        controller: TextEditingController(
                          text: widget.user.email,
                        ),
                        readOnly: true,
                        suffixIcon: Icon(
                          Icons.lock_outline_rounded,
                          size: 19,
                          color: colorScheme.onSurface.withValues(alpha: 0.45),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'رقم الهاتف',
                        style: TextStyles.semiBold13.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),

                      const SizedBox(height: 8),

                      CustomTextFormField(
                        validator: (value) {
                          final phone = value?.trim() ?? '';

                          if (phone.isEmpty) {
                            return 'من فضلك أدخل رقم الهاتف';
                          }

                          if (!RegExp(r'^01[0125][0-9]{8}$').hasMatch(phone)) {
                            return 'أدخل رقم هاتف مصري صحيح';
                          }

                          return null;
                        },
                        maxLines: 1,
                        keyboardType: TextInputType.phone,
                        colorScheme: colorScheme,
                        hint: "ادخل رقم الهاتف",
                        controller: _phoneController,
                      ),

                      const SizedBox(height: 32),

                      BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, state) {
                          final isLoading = state is ProfileUpdating;

                          return CustomButtonWidget(
                            text: "حفظ التعديلات",
                            onTap: isLoading ? null : _updateProfile,
                            isLoading: isLoading,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
