part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class PerformingLoading extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginWithError extends LoginState {
  final String error;

  LoginWithError(this.error);
  @override
  List<Object> get props => [error];
}

class SuccesfulLogin extends LoginState {
  @override
  List<Object> get props => [];
}
