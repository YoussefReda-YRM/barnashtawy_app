import 'dart:convert';
import 'dart:developer';

import 'package:barnasht_app/core/constatnts.dart';
import 'package:barnasht_app/core/errors/email_alredy_in_use_exception.dart';
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
      try {
        // محاولة إنشاء حساب جديد
        user = await firebaseAuthService.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // إرسال رسالة تأكيد البريد
        final verificationResult = await sendEmailVerification();

        verificationResult.fold(
          (failure) => throw CustomException(message: failure.message),
          (_) {},
        );
      } on EmailAlreadyInUseException {
        // الحساب موجود بالفعل، نحاول تسجيل الدخول
        user = await firebaseAuthService.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // الحساب موجود ولكن لم يتم تأكيد البريد
        if (!user.emailVerified) {
          final verificationResult = await sendEmailVerification();

          verificationResult.fold(
            (failure) => throw CustomException(message: failure.message),
            (_) {},
          );
        } else {
          // الحساب مؤكد بالفعل
          await firebaseAuthService.signOut();

          throw CustomException(
            message: 'هذا البريد الإلكتروني مسجل بالفعل. الرجاء تسجيل الدخول.',
          );
        }
      }

      final userEntity = UserEntity(
        name: name,
        email: email,
        uId: user.uid,
        phoneNumber: phoneNumber,
      );

      // إضافة بيانات المستخدم إذا كانت غير موجودة
      final isUserExist = await databaseService.checkIfDataExists(
        path: BackendEndpoint.isUserExists,
        documentId: user.uid,
      );

      if (!isUserExist) {
        await addUserData(user: userEntity);
      }

      return right(userEntity);
    } on CustomException catch (e) {
      await deleteUser(user);
      return left(ServerFailure(e.message));
    } catch (e) {
      await deleteUser(user);

      log(
        'Exception in AuthRepoImpl.createUserWithEmailAndPassword: '
        '${e.toString()}',
      );

      return left(ServerFailure('حدث خطأ ما. الرجاء المحاولة مرة أخرى.'));
    }
  }

  @override
  Future<Either<Failure, bool>> isEmailVerified() async {
    try {
      final isVerified = await firebaseAuthService.isEmailVerified();

      return right(isVerified);
    } on CustomException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      log('Exception in AuthRepoImpl.isEmailVerified: ${e.toString()}');

      return left(ServerFailure('حدث خطأ أثناء التحقق من البريد الإلكتروني.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendEmailVerification() async {
    try {
      await firebaseAuthService.sendEmailVerification();

      return right(unit);
    } on CustomException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      log('Exception in AuthRepoImpl.sendEmailVerification: ${e.toString()}');

      return left(ServerFailure('تعذر إرسال رابط تأكيد البريد الإلكتروني.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuthService.sendPasswordResetEmail(email: email);

      return right(unit);
    } on CustomException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      log(
        'Exception in AuthRepoImpl.sendPasswordResetEmail: '
        '${e.toString()}',
      );

      return left(ServerFailure('حدث خطأ ما. الرجاء المحاولة مرة أخرى.'));
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

      if (!user.emailVerified) {
        await firebaseAuthService.signOut();

        return left(
          ServerFailure(
            'يجب تأكيد البريد الإلكتروني أولًا. تحقق من بريدك الإلكتروني ثم حاول تسجيل الدخول مرة أخرى.',
          ),
        );
      }

      final userEntity = await getUserData(uid: user.uid);

      await saveUserData(user: userEntity);

      return right(userEntity);
    } on CustomException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      log(
        'Exception in AuthRepoImpl.signinWithEmailAndPassword: '
        '${e.toString()}',
      );

      return left(ServerFailure('حدث خطأ ما. الرجاء المحاولة مرة أخرى.'));
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

  @override
  Future<Either<Failure, Unit>> deleteUserData() async {
    try {
      final currentUser = firebaseAuthService.currentUser;

      if (currentUser == null) {
        return left(ServerFailure('يجب تسجيل الدخول أولاً.'));
      }

      await databaseService.deleteData(
        path: BackendEndpoint.addUserData,
        documentId: currentUser.uid,
      );

      return right(unit);
    } on CustomException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      log(
        'Exception in AuthRepoImpl.deleteUserData: '
        '${e.toString()}',
      );

      return left(ServerFailure('حدث خطأ أثناء حذف بيانات الحساب.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> reauthenticate({String? password}) async {
    try {
      await firebaseAuthService.reauthenticate(password: password);

      return right(unit);
    } on CustomException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      log(
        'Exception in AuthRepoImpl.reauthenticate: '
        '${e.toString()}',
      );

      return left(ServerFailure('حدث خطأ أثناء التحقق من هوية الحساب.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount() async {
    try {
      await firebaseAuthService.deleteAccount();

      return right(unit);
    } on CustomException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      log(
        'Exception in AuthRepoImpl.deleteAccount: '
        '${e.toString()}',
      );

      return left(
        ServerFailure('حدث خطأ أثناء حذف الحساب. الرجاء المحاولة مرة أخرى.'),
      );
    }
  }
}
