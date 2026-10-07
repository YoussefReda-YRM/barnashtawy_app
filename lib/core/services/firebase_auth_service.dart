import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:barnasht_app/core/errors/email_alredy_in_use_exception.dart';
import 'package:barnasht_app/core/errors/exceptions.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log(
        "Exception in FirebaseAuthService.createUserWithEmailAndPassword: "
        "${e.toString()} and code is ${e.code}",
      );

      if (e.code == 'weak-password') {
        throw CustomException(message: 'الرقم السري ضعيف جداً.');
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseException();
      } else if (e.code == 'network-request-failed') {
        throw CustomException(message: 'تاكد من اتصالك بالانترنت.');
      } else {
        throw CustomException(
          message: 'لقد حدث خطأ ما. الرجاء المحاولة مرة اخرى.',
        );
      }
    } catch (e) {
      log(
        "Exception in FirebaseAuthService.createUserWithEmailAndPassword: "
        "${e.toString()}",
      );

      throw CustomException(
        message: 'لقد حدث خطأ ما. الرجاء المحاولة مرة اخرى.',
      );
    }
  }

  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log(
        "Exception in FirebaseAuthService.signInWithEmailAndPassword: "
        "${e.toString()} and code is ${e.code}",
      );

      if (e.code == 'user-not-found') {
        throw CustomException(
          message: 'الرقم السري او البريد الالكتروني غير صحيح.',
        );
      } else if (e.code == 'wrong-password') {
        throw CustomException(
          message: 'الرقم السري او البريد الالكتروني غير صحيح.',
        );
      } else if (e.code == 'invalid-credential') {
        throw CustomException(
          message: 'الرقم السري او البريد الالكتروني غير صحيح.',
        );
      } else if (e.code == 'network-request-failed') {
        throw CustomException(message: 'تاكد من اتصالك بالانترنت.');
      } else {
        throw CustomException(
          message: 'لقد حدث خطأ ما. الرجاء المحاولة مرة اخرى.',
        );
      }
    } catch (e) {
      log(
        "Exception in FirebaseAuthService.signInWithEmailAndPassword: "
        "${e.toString()}",
      );

      throw CustomException(
        message: 'لقد حدث خطأ ما. الرجاء المحاولة مرة اخرى.',
      );
    }
  }

  Future<bool> isEmailVerified() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return false;
      }

      await user.reload();

      return FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    } on FirebaseAuthException catch (e) {
      log(
        'Exception in FirebaseAuthService.isEmailVerified: '
        '${e.toString()} and code is ${e.code}',
      );

      throw CustomException(
        message: 'حدث خطأ أثناء التحقق من البريد الإلكتروني.',
      );
    } catch (e) {
      log(
        'Exception in FirebaseAuthService.isEmailVerified: '
        '${e.toString()}',
      );

      throw CustomException(
        message: 'حدث خطأ أثناء التحقق من البريد الإلكتروني.',
      );
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      log(
        'Exception in FirebaseAuthService.sendEmailVerification: '
        '${e.toString()} and code is ${e.code}',
      );

      if (e.code == 'network-request-failed') {
        throw CustomException(message: 'تأكد من اتصالك بالإنترنت.');
      } else if (e.code == 'too-many-requests') {
        throw CustomException(
          message: 'تم إرسال عدد كبير من الطلبات. حاول مرة أخرى لاحقًا.',
        );
      } else {
        throw CustomException(
          message: 'تعذر إرسال رابط تأكيد البريد الإلكتروني.',
        );
      }
    } catch (e) {
      log(
        'Exception in FirebaseAuthService.sendEmailVerification: '
        '${e.toString()}',
      );

      throw CustomException(
        message: 'تعذر إرسال رابط تأكيد البريد الإلكتروني.',
      );
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      log(
        'Exception in FirebaseAuthService.sendPasswordResetEmail: '
        '${e.toString()} and code is ${e.code}',
      );

      if (e.code == 'user-not-found') {
        throw CustomException(
          message: 'لا يوجد حساب مسجل بهذا البريد الإلكتروني.',
        );
      } else if (e.code == 'invalid-email') {
        throw CustomException(message: 'البريد الإلكتروني غير صحيح.');
      } else if (e.code == 'network-request-failed') {
        throw CustomException(message: 'تأكد من اتصالك بالإنترنت.');
      } else if (e.code == 'too-many-requests') {
        throw CustomException(
          message: 'تم إرسال عدد كبير من الطلبات. حاول مرة أخرى لاحقًا.',
        );
      } else {
        throw CustomException(
          message: 'تعذر إرسال رابط إعادة تعيين كلمة السر.',
        );
      }
    } catch (e) {
      log(
        'Exception in FirebaseAuthService.sendPasswordResetEmail: '
        '${e.toString()}',
      );

      throw CustomException(message: 'تعذر إرسال رابط إعادة تعيين كلمة السر.');
    }
  }

  Future<User> signInWithGoogle() async {
    final googleUser = await GoogleSignIn.instance.authenticate();

    final googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );

    return userCredential.user!;
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';

    final random = math.Random.secure();

    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);

    return digest.toString();
  }

  User? get currentUser => FirebaseAuth.instance.currentUser;

  bool isLoggedIn() {
    final user = FirebaseAuth.instance.currentUser;

    return user != null;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future deleteUser() async {
    await FirebaseAuth.instance.currentUser!.delete();
  }

  Future<void> deleteAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw CustomException(message: 'لا يوجد مستخدم مسجل الدخول حاليًا.');
      }

      await user.delete();
    } on FirebaseAuthException catch (e) {
      log(
        'Exception in FirebaseAuthService.deleteAccount: '
        '${e.toString()} and code is ${e.code}',
      );

      if (e.code == 'requires-recent-login') {
        throw CustomException(
          message: 'لأسباب أمنية، يجب تسجيل الدخول مرة أخرى قبل حذف الحساب.',
        );
      } else if (e.code == 'network-request-failed') {
        throw CustomException(message: 'تأكد من اتصالك بالإنترنت.');
      } else {
        throw CustomException(
          message: 'تعذر حذف الحساب. الرجاء المحاولة مرة أخرى.',
        );
      }
    } catch (e) {
      log(
        'Exception in FirebaseAuthService.deleteAccount: '
        '${e.toString()}',
      );

      if (e is CustomException) {
        rethrow;
      }

      throw CustomException(message: 'حدث خطأ أثناء حذف الحساب.');
    }
  }

  Future<void> reauthenticate({String? password}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw CustomException(message: 'لا يوجد مستخدم مسجل الدخول حاليًا.');
      }

      final providerIds = user.providerData
          .map((provider) => provider.providerId)
          .toList();

      // ----------------------------------------------------------
      // Email & Password
      // ----------------------------------------------------------

      if (providerIds.contains('password')) {
        if (password == null || password.isEmpty) {
          throw CustomException(message: 'أدخل كلمة السر الحالية للمتابعة.');
        }

        final email = user.email;

        if (email == null || email.isEmpty) {
          throw CustomException(
            message: 'تعذر الحصول على البريد الإلكتروني للحساب.',
          );
        }

        final credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );

        await user.reauthenticateWithCredential(credential);

        return;
      }

      // ----------------------------------------------------------
      // Google
      // ----------------------------------------------------------

      if (providerIds.contains('google.com')) {
        final googleUser = await GoogleSignIn.instance.authenticate();

        final googleAuth = googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );

        await user.reauthenticateWithCredential(credential);

        return;
      }

      throw CustomException(
        message: 'طريقة تسجيل الدخول الحالية لا تدعم إعادة التحقق.',
      );
    } on FirebaseAuthException catch (e) {
      log(
        'Exception in FirebaseAuthService.reauthenticate: '
        '${e.toString()} and code is ${e.code}',
      );

      if (e.code == 'wrong-password' ||
          e.code == 'invalid-credential' ||
          e.code == 'invalid-login-credentials') {
        throw CustomException(message: 'كلمة السر الحالية غير صحيحة.');
      }

      if (e.code == 'user-mismatch') {
        throw CustomException(
          message: 'بيانات تسجيل الدخول لا تطابق الحساب الحالي.',
        );
      }

      if (e.code == 'network-request-failed') {
        throw CustomException(message: 'تأكد من اتصالك بالإنترنت.');
      }

      if (e.code == 'too-many-requests') {
        throw CustomException(
          message: 'تم إرسال عدد كبير من الطلبات. حاول مرة أخرى لاحقًا.',
        );
      }

      throw CustomException(message: 'تعذر التحقق من هوية الحساب.');
    } catch (e) {
      log(
        'Exception in FirebaseAuthService.reauthenticate: '
        '${e.toString()}',
      );

      if (e is CustomException) {
        rethrow;
      }

      throw CustomException(message: 'حدث خطأ أثناء التحقق من هوية الحساب.');
    }
  }
}
