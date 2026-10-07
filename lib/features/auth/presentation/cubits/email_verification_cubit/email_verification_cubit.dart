import 'package:barnasht_app/features/auth/domain/repos/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'email_verification_state.dart';

class EmailVerificationCubit extends Cubit<EmailVerificationState> {
  EmailVerificationCubit(this.authRepo) : super(EmailVerificationInitial());

  final AuthRepo authRepo;

  Future<void> checkEmailVerification() async {
    emit(EmailVerificationLoading());

    var result = await authRepo.isEmailVerified();

    result.fold(
      (failure) => emit(EmailVerificationFailure(message: failure.message)),
      (isVerified) {
        if (isVerified) {
          emit(EmailVerificationSuccess());
        } else {
          emit(EmailVerificationNotVerified());
        }
      },
    );
  }

  Future<void> resendVerificationEmail() async {
    emit(EmailVerificationLoading());

    var result = await authRepo.sendEmailVerification();

    result.fold(
      (failure) => emit(EmailVerificationFailure(message: failure.message)),
      (_) => emit(EmailVerificationResendSuccess()),
    );
  }
}
