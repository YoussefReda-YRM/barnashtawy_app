import 'package:barnasht_app/core/widgets/build_bar.dart';
import 'package:barnasht_app/core/widgets/custom_progress_hud.dart';
import 'package:barnasht_app/features/auth/presentation/cubits/signin_cubit/signin_cubit.dart';
import 'package:barnasht_app/features/auth/presentation/views/widgets/signin_widgets/signin_view_body.dart';
import 'package:barnasht_app/features/home/presentation/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninViewBodyBlocConsumer extends StatelessWidget {
  const SigninViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigninCubit, SigninState>(
      listener: (context, state) {
        if (state is SigninSuccess) {
          Navigator.pushNamed(context, HomeView.routeName);
        }

        if (state is SigninFailure) {
          buildBar(context, state.message, type: SnackBarType.error);
        }
      },
      builder: (context, state) {
        return CustomProgressHud(
          isLoading: state is SigninLoading ? true : false,
          child: const SigninViewBody(),
        );
      },
    );
  }
}
