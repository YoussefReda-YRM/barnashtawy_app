import 'package:barnasht_app/core/services/firebase_auth_service.dart';
import 'package:barnasht_app/core/services/get_it_service.dart';
import 'package:barnasht_app/core/widgets/build_bar.dart';
import 'package:barnasht_app/core/widgets/custom_app_bar.dart';
import 'package:barnasht_app/features/home/presentation/cubits/category_cubit.dart';
import 'package:barnasht_app/features/home/presentation/cubits/category_state.dart';
import 'package:barnasht_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:barnasht_app/features/profile/presentation/cubits/profile_state.dart';
import 'package:barnasht_app/features/profile/presentation/views/widgets/profile_loading_view.dart';
import 'package:barnasht_app/features/profile/presentation/views/widgets/profile_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({
    super.key,
    required this.onLoggedOut,
  });

  static const String routeName = 'profile_view';

  final VoidCallback onLoggedOut;

  @override
  Widget build(BuildContext context) {
    final currentUser = getIt<FirebaseAuthService>().currentUser;

    // المستخدم غير مسجل دخول
    if (currentUser == null) {
      return Column(
        children: [
          customAppBar(
            context,
            title: 'الملف الشخصي',
            showBackButton: false,
          ),
          const Expanded(
            child: Center(
              child: Text(
                'يجب تسجيل الدخول أولاً',
              ),
            ),
          ),
        ],
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<ProfileCubit>()
            ..getProfile(
              uid: currentUser.uid,
            ),
        ),
        BlocProvider(
          create: (_) => getIt<CategoryCubit>()
            ..getCategories(),
        ),
      ],
      child: Column(
        children: [
          customAppBar(
            context,
            title: 'الملف الشخصي',
            showBackButton: false,
          ),
          Expanded(
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, profileState) {
                if (profileState is ProfileLoading) {
                  return const ProfileLoadingView();
                }

                if (profileState is ProfileFailure) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (context.mounted) {
                      buildBar(
                        context,
                        profileState.message,
                        type: SnackBarType.error,
                      );
                    }
                  });

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        profileState.message,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                if (profileState is ProfileSuccess) {
                  return BlocBuilder<CategoryCubit, CategoryState>(
                    builder: (context, categoryState) {
                      if (categoryState is CategoryLoading ||
                          categoryState is CategoryInitial) {
                        return const ProfileLoadingView();
                      }

                      if (categoryState is CategoryFailure) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              categoryState.errorMessage,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      if (categoryState is CategorySuccess) {
                        return ProfileViewBody(
                          user: profileState.user,
                          places: profileState.places,
                          categories: categoryState.categories,
                          onLoggedOut: onLoggedOut,
                        );
                      }

                      return const SizedBox();
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}