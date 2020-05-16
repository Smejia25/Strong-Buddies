import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginWithPhoneResults {}

class CodeSent extends LoginWithPhoneResults {
  final String verificationId;

  CodeSent(this.verificationId);
}

class ExceptionRaised extends LoginWithPhoneResults {
  final AuthException exception;

  ExceptionRaised(this.exception);
}

class SucesfulLoginWithNumber extends LoginWithPhoneResults {
  final AuthResult authResult;

  SucesfulLoginWithNumber(this.authResult);
}
