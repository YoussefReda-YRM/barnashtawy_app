part of 'email_verification_cubit.dart';

abstract class EmailVerificationState {}

class EmailVerificationInitial extends EmailVerificationState {}

class EmailVerificationLoading extends EmailVerificationState {}

class EmailVerificationSuccess extends EmailVerificationState {}

class EmailVerificationNotVerified extends EmailVerificationState {}

class EmailVerificationResendSuccess extends EmailVerificationState {}

class EmailVerificationFailure extends EmailVerificationState {
  final String message;

  EmailVerificationFailure({
    required this.message,
  });
}