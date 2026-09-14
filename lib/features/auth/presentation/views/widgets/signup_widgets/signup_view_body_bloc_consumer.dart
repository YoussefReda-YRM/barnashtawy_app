import 'package:barnasht_app/core/widgets/build_bar.dart';
import 'package:barnasht_app/features/auth/presentation/cubits/signup_cubit/signup_cubit.dart';
import 'package:barnasht_app/features/auth/presentation/views/widgets/signup_widgets/signup_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignupViewBodyBlocConsumer extends StatelessWidget {
  const SignupViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          Navigator.pop(context);
          buildBar(
            context,
            'تم إنشاء الحساب بنجاح',
            type: SnackBarType.success,
          );
        }
        if (state is SignupFailure) {
          buildBar(context, state.message, type: SnackBarType.error);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is SignupLoading ? true : false,
          child: const SignupViewBody(),
        );
      },
    );
  }
}
