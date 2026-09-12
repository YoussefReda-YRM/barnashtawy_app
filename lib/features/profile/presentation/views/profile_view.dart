import 'package:barnasht_app/core/services/firebase_auth_service.dart';
import 'package:barnasht_app/core/services/get_it_service.dart';
import 'package:barnasht_app/core/widgets/build_bar.dart';
import 'package:barnasht_app/core/widgets/custom_app_bar.dart';
import 'package:barnasht_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:barnasht_app/features/profile/presentation/cubits/profile_state.dart';
import 'package:barnasht_app/features/profile/presentation/views/widgets/profile_loading_view.dart';
import 'package:barnasht_app/features/profile/presentation/views/widgets/profile_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  static const String routeName = 'profile_view';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final currentUser = getIt<FirebaseAuthService>().currentUser;

    if (currentUser == null) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              customAppBar(
                context,
                title: 'الملف الشخصي',
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'يجب تسجيل الدخول أولاً',
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return BlocProvider(
      create: (_) => getIt<ProfileCubit>()
        ..getProfile(
          uid: currentUser.uid,
        ),
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              customAppBar(
                context,
                title: 'الملف الشخصي',
              ),
              Expanded(
                child: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoading) {
                      return const ProfileLoadingView();
                    }

                    if (state is ProfileFailure) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (context.mounted) {
                          buildBar(
                            context,
                            state.message,
                            type: SnackBarType.error,
                          );
                        }
                      });

                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            state.message,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    if (state is ProfileSuccess) {
                      return ProfileViewBody(
                        user: state.user,
                        places: state.places,
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}