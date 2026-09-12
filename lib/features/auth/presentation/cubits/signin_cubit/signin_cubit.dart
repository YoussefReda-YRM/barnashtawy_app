import 'package:barnasht_app/features/auth/domain/entities/auth_entity.dart';
import 'package:barnasht_app/features/auth/domain/repos/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit(this.authRepo) : super(SigninInitial());
  final AuthRepo authRepo;

  Future<void> signin(String email, String password) async {
    emit(SigninLoading());
    var result = await authRepo.signinWithEmailAndPassword(email, password);
    result.fold(
      (failure) => emit(SigninFailure(message: failure.message)),
      (userEntity) => emit(SigninSuccess(userEntity: userEntity)),
    );
  }

  Future<void> signinWithGoogle() async {
    emit(SigninLoading());
    var result = await authRepo.signinWithGoogle();
    result.fold(
      (failure) => emit(SigninFailure(message: failure.message)),
      (userEntity) => emit(SigninSuccess(userEntity: userEntity)),
    );
  }
}
