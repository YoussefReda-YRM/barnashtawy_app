import 'package:barnasht_app/features/permissions/presentation/cubits/permission_onboarding_cubit.dart';
import 'package:barnasht_app/features/permissions/presentation/views/widgets/permission_loading_view.dart';
import 'package:barnasht_app/features/permissions/presentation/views/widgets/permission_page.dart';
import 'package:barnasht_app/features/permissions/presentation/views/widgets/permission_page_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PermissionOnboardingContent extends StatelessWidget {
  const PermissionOnboardingContent({
    super.key,
    required this.onOpenLocationSettings,
    required this.onOpenLocationAppSettings,
  });

  final VoidCallback onOpenLocationSettings;
  final VoidCallback onOpenLocationAppSettings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<PermissionOnboardingCubit, PermissionOnboardingStep>(
          builder: (context, step) {
            if (step == PermissionOnboardingStep.loading) {
              return const PermissionLoadingView();
            }

            final isLocation = step == PermissionOnboardingStep.location;

            final isLocationServiceDisabled =
                step == PermissionOnboardingStep.locationServiceDisabled;

            final isLocationPermanentlyDenied =
                step == PermissionOnboardingStep.locationPermanentlyDenied;

            if (isLocation ||
                isLocationServiceDisabled ||
                isLocationPermanentlyDenied) {
              return PermissionPage(
                type: PermissionPageType.location,
                title: isLocationPermanentlyDenied
                    ? 'موقعك مهم لرفيق'
                    : 'خلّي رفيق أقرب ليك',
                description:
                    'عشان نعرض لك الأماكن والخدمات الموجودة حواليك، '
                    'رفيق محتاج يعرف موقعك الحالي أثناء استخدام التطبيق.',
                buttonText: isLocationPermanentlyDenied
                    ? 'فتح إعدادات التطبيق'
                    : isLocationServiceDisabled
                    ? 'تفعيل خدمة الموقع'
                    : 'السماح بالوصول للموقع',
                onPressed: () {
                  final cubit = context.read<PermissionOnboardingCubit>();

                  if (isLocationPermanentlyDenied) {
                    onOpenLocationAppSettings();
                    return;
                  }

                  if (isLocationServiceDisabled) {
                    onOpenLocationSettings();
                    return;
                  }

                  cubit.requestLocation();
                },
              );
            }

            if (step == PermissionOnboardingStep.notification) {
              return PermissionPage(
                type: PermissionPageType.notification,
                title: 'خليك دايمًا في الصورة',
                description:
                    'فعّل إشعارات رفيق عشان توصلك التنبيهات المهمة '
                    'ورسائل الشات الجديدة في وقتها.',
                buttonText: 'تفعيل الإشعارات',
                onPressed: () {
                  context
                      .read<PermissionOnboardingCubit>()
                      .requestNotification();
                },
                secondaryText: 'لاحقًا',
                onSecondaryPressed: () {
                  context.read<PermissionOnboardingCubit>().skipNotification();
                },
              );
            }

            return const PermissionLoadingView();
          },
        ),
      ),
    );
  }
}
