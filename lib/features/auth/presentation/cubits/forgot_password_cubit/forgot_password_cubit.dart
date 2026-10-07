import 'package:barnasht_app/features/auth/domain/repos/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this.authRepo)
      : super(ForgotPasswordInitial());

  final AuthRepo authRepo;

  Future<void> sendPasswordResetEmail(String email) async {
    emit(ForgotPasswordLoading());

    final result = await authRepo.sendPasswordResetEmail(
      email.trim(),
    );

    result.fold(
      (failure) => emit(
        ForgotPasswordFailure(
          message: failure.message,
        ),
      ),
      (_) => emit(
        ForgotPasswordSuccess(),
      ),
    );
  }
}