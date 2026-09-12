import 'package:barnasht_app/core/services/get_it_service.dart';
import 'package:barnasht_app/features/auth/domain/repos/auth_repo.dart';
import 'package:barnasht_app/features/auth/presentation/cubits/signin_cubit/signin_cubit.dart';
import 'package:barnasht_app/features/auth/presentation/views/widgets/signin_widgets/signin_view_body_bloc_consumer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninView extends StatelessWidget {
  const SigninView({super.key});

  static const String routeName = 'login_view';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SigninCubit(getIt.get<AuthRepo>()),
      child: Scaffold(
        body: SafeArea(child: const SigninViewBodyBlocConsumer()),
      ),
    );
  }
}
