import 'package:barnasht_app/core/services/firebase_auth_service.dart';
import 'package:barnasht_app/core/services/get_it_service.dart';
import 'package:barnasht_app/core/widgets/show_custom_app_dialog.dart';
import 'package:barnasht_app/features/auth/presentation/views/signin_view.dart';
import 'package:barnasht_app/features/home/presentation/views/widgets/custom_bottom_navigation_bar.dart';
import 'package:barnasht_app/features/home/presentation/views/widgets/main_view_body.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  static const String routeName = 'main_view';

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentViewIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final authService = getIt<FirebaseAuthService>();

    return Scaffold(
      backgroundColor: colorScheme.surface,

      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: currentViewIndex,
        onItemTapped: (index) {
          // Profile
          if (index == 2 && !authService.isLoggedIn()) {
            showCustomAppDialog(
              context: context,
              title: 'تسجيل الدخول مطلوب',
              message: 'يجب تسجيل الدخول أولاً للوصول إلى الملف الشخصي.',
              icon: Icons.login,
              confirmText: 'تسجيل الدخول',
              onConfirm: () async {
                Navigator.pop(context);

                final result = await Navigator.pushNamed(
                  context,
                  SigninView.routeName,
                );

                if (result == true && mounted) {
                  setState(() {
                    currentViewIndex = 2;
                  });
                }
              },
            );

            return;
          }

          setState(() {
            currentViewIndex = index;
          });
        },
      ),

      body: SafeArea(
        child: MainViewBody(
          currentViewIndex: currentViewIndex,
          isLoggedIn: authService.isLoggedIn(),
          onLoggedOut: () {
            if (!mounted) return;

            setState(() {
              currentViewIndex = 0;
            });

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;

              setState(() {});
            });
          },
        ),
      ),
    );
  }
}
