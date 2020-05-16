part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class PerformLoginWithCredentials extends LoginEvent {
  final String email;
  final String password;

  const PerformLoginWithCredentials(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class PerformLoginWithGoogle extends LoginEvent {
  @override
  List<Object> get props => [];
}

class PerformLoginWithFacebook extends LoginEvent {
  @override
  List<Object> get props => [];
}

class ChangeToRegisterProcess extends LoginEvent {
  @override
  List<Object> get props => [];
}

class ChangeToLoginProcess extends LoginEvent {
  @override
  List<Object> get props => [];
}
