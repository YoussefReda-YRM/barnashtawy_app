import 'package:barnasht_app/core/errors/failures.dart';
import 'package:barnasht_app/features/auth/domain/entities/auth_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
    String phoneNumber,
  );

  Future<Either<Failure, UserEntity>> signinWithEmailAndPassword(
    String email,
    String password,
  );

  Future<Either<Failure, bool>> isEmailVerified();

  Future<Either<Failure, void>> sendEmailVerification();

  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email);

  Future<Either<Failure, UserEntity>> signinWithGoogle();

  Future addUserData({required UserEntity user});

  Future saveUserData({required UserEntity user});

  Future<UserEntity> getUserData({required String uid});
  Future<void> updateUserData({required UserEntity user});

  Future<Either<Failure, Unit>> deleteUserData();

  Future<Either<Failure, Unit>> deleteAccount();

  Future<Either<Failure, Unit>> reauthenticate({String? password});
}
