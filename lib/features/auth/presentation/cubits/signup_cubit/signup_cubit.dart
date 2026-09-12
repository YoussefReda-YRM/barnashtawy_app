import 'package:barnasht_app/features/auth/domain/entities/auth_entity.dart';
import 'package:barnasht_app/features/auth/domain/repos/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit(this.authRepo) : super(SignupInitial());

  final AuthRepo authRepo;

  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
    String phoneNumber,
  ) async {
    emit(SignupLoading());

    final result = await authRepo.createUserWithEmailAndPassword(
      email,
      password,
      name,
      phoneNumber,
    );

    result.fold(
      (failure) => emit(
        SignupFailure(message: failure.message),
      ),
      (userEntity) => emit(
        SignupSuccess(userEntity: userEntity),
      ),
    );
  }
}