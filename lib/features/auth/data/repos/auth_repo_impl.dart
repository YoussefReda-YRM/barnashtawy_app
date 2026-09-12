import 'dart:convert';
import 'dart:developer';

import 'package:barnasht_app/core/constatnts.dart';
import 'package:barnasht_app/core/errors/exceptions.dart';
import 'package:barnasht_app/core/errors/failures.dart';
import 'package:barnasht_app/core/services/database_service.dart';
import 'package:barnasht_app/core/services/firebase_auth_service.dart';
import 'package:barnasht_app/core/services/shared_preferences_singleton.dart';
import 'package:barnasht_app/core/utils/back_end_point.dart';
import 'package:barnasht_app/features/auth/data/models/auth_model.dart';
import 'package:barnasht_app/features/auth/domain/entities/auth_entity.dart';
import 'package:barnasht_app/features/auth/domain/repos/auth_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuthService firebaseAuthService;
  final DatabaseService databaseService;

  AuthRepoImpl({
    required this.databaseService,
    required this.firebaseAuthService,
  });

  @override
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
    String phoneNumber,
  ) async {
    User? user;

    try {
      user = await firebaseAuthService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userEntity = UserEntity(
        name: name,
        email: email,
        uId: user.uid,
        phoneNumber: phoneNumber,
      );

      await addUserData(user: userEntity);

      return right(userEntity);
    } on CustomException catch (e) {
      await deleteUser(user);
      return left(ServerFailure(e.message));
    } catch (e) {
      await deleteUser(user);

      log(
        'Exception in AuthRepoImpl.createUserWithEmailAndPassword: ${e.toString()}',
      );

      return left(ServerFailure('حدث خطأ ما. الرجاء المحاولة مرة اخرى.'));
    }
  }

  Future<void> deleteUser(User? user) async {
    if (user != null) {
      await firebaseAuthService.deleteUser();
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signinWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final user = await firebaseAuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userEntity = await getUserData(uid: user.uid);

      await saveUserData(user: userEntity);

      return right(userEntity);
    } on CustomException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      log(
        'Exception in AuthRepoImpl.createUserWithEmailAndPassword: ${e.toString()}',
      );

      return left(ServerFailure('حدث خطأ ما. الرجاء المحاولة مرة اخرى.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signinWithGoogle() async {
    User? user;

    try {
      user = await firebaseAuthService.signInWithGoogle();

      final userEntity = UserModel.fromFirebaseUser(user);

      final isUserExist = await databaseService.checkIfDataExists(
        path: BackendEndpoint.isUserExists,
        documentId: user.uid,
      );

      if (isUserExist) {
        final existingUser = await getUserData(uid: user.uid);
        await saveUserData(user: existingUser);

        return right(existingUser);
      } else {
        await addUserData(user: userEntity);
        await saveUserData(user: userEntity);

        return right(userEntity);
      }
    } catch (e) {
      await deleteUser(user);

      log('Exception in AuthRepoImpl.signinWithGoogle: ${e.toString()}');

      return left(ServerFailure('حدث خطأ ما. الرجاء المحاولة مرة اخرى.'));
    }
  }

  @override
  Future<void> addUserData({required UserEntity user}) async {
    await databaseService.addData(
      path: BackendEndpoint.addUserData,
      data: UserModel.fromEntity(user).toMap(),
      documentId: user.uId,
    );
  }

  @override
  Future<UserEntity> getUserData({required String uid}) async {
    final userData = await databaseService.getData(
      path: BackendEndpoint.getUsersData,
      documentId: uid,
    );

    return UserModel.fromJson(userData);
  }

  @override
  Future<void> saveUserData({required UserEntity user}) async {
    final jsonData = jsonEncode(UserModel.fromEntity(user).toMap());

    await Prefs.setString(kUserData, jsonData);
  }

  @override
  Future<void> updateUserData({required UserEntity user}) async {
    await databaseService.updateData(
      path: BackendEndpoint.addUserData,
      documentId: user.uId,
      data: UserModel.fromEntity(user).toMap(),
    );

    await saveUserData(user: user);
  }
}
