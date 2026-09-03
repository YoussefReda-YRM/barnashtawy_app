import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// إرسال كود OTP إلى رقم الهاتف
  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,

        // Android
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _firebaseAuth.signInWithCredential(credential);
          } catch (e) {
            log(
              'Exception in FirebaseAuthService.verificationCompleted: $e',
            );
          }
        },

        verificationFailed: (FirebaseAuthException e) {
          log(
            'Exception in FirebaseAuthService.verificationFailed: '
            '${e.toString()} | code: ${e.code}',
          );

          throw e;
        },

        // إرسال الـ OTP بنجاح
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },

        codeAutoRetrievalTimeout: (String verificationId) {
          log(
            'FirebaseAuthService.codeAutoRetrievalTimeout: $verificationId',
          );
        },
      );
    } catch (e) {
      log(
        'Exception in FirebaseAuthService.sendOtp: ${e.toString()}',
      );

      rethrow;
    }
  }

  /// التحقق من كود OTP وتسجيل الدخول
  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final PhoneAuthCredential credential =
          PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      log(
        'Exception in FirebaseAuthService.verifyOtp: '
        '${e.toString()} | code: ${e.code}',
      );

      rethrow;
    } catch (e) {
      log(
        'Exception in FirebaseAuthService.verifyOtp: ${e.toString()}',
      );

      rethrow;
    }
  }

  /// إعادة إرسال OTP
  Future<void> resendOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
  }) async {
    await sendOtp(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
    );
  }

  /// المستخدم الحالي
  User? get currentUser => _firebaseAuth.currentUser;

  /// هل المستخدم مسجل دخول؟
  bool isLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }

  /// تسجيل الخروج
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// حذف الحساب
  Future<void> deleteUser() async {
    await _firebaseAuth.currentUser?.delete();
  }
}