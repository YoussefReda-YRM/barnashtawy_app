import 'package:barnasht_app/core/services/firebase_auth_service.dart';
import 'package:barnasht_app/core/services/get_it_service.dart';
import 'package:barnasht_app/core/theme/theme_cubit.dart';
import 'package:barnasht_app/core/widgets/custom_header_icon_widget.dart';
import 'package:barnasht_app/core/widgets/custom_logo_widget.dart';
import 'package:barnasht_app/core/widgets/show_custom_app_dialog.dart';
import 'package:barnasht_app/features/auth/presentation/views/signin_view.dart';
import 'package:barnasht_app/features/favorite_places/presentation/views/favorites_view.dart';
import 'package:barnasht_app/features/profile/presentation/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        const CustomLogoWidget(),

        const Spacer(),
        CustomHeaderIconWidget(
          widget: Icon(
            Icons.favorite_border,
            size: 22,
            color: colorScheme.primary,
          ),
          onTap: () {
            Navigator.pushNamed(context, FavoritesView.routeName);
          },
        ),

        const SizedBox(width: 10),

        CustomHeaderIconWidget(
          widget: Icon(
            Icons.person_outline,
            size: 22,
            color: colorScheme.primary,
          ),
          onTap: () {
            final authService = getIt<FirebaseAuthService>();

            if (authService.isLoggedIn()) {
              Navigator.pushNamed(context, ProfileView.routeName);
              return;
            }

            showCustomAppDialog(
              context: context,
              title: "تسجيل الدخول مطلوب",
              message: "يجب تسجيل الدخول أولاً للوصول إلى الملف الشخصي.",
              icon: Icons.login,
              confirmText: "تسجيل الدخول",
              onConfirm: () async {
                await Navigator.pushNamed(context, SigninView.routeName);
              },
            );
          },
        ),

        const SizedBox(width: 10),

        CustomHeaderIconWidget(
          widget: Icon(
            Theme.of(context).brightness == Brightness.dark
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
            size: 22,
            color: colorScheme.primary,
          ),
          onTap: () {
            context.read<ThemeCubit>().toggleTheme();
          },
        ),
      ],
    );
  }
}
