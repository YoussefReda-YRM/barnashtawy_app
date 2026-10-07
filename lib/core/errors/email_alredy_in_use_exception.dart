import 'package:barnasht_app/core/errors/exceptions.dart';

class EmailAlreadyInUseException extends CustomException {
  EmailAlreadyInUseException()
    : super(message: 'البريد الإلكتروني مستخدم بالفعل.');
}
