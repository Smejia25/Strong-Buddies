part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();
}

class RegisterInitial extends RegisterState {
  @override
  List<Object> get props => [];
}

class RegisterInProcess extends RegisterState {
  @override
  List<Object> get props => [];
}

class RegisterSucessful extends RegisterState {
  @override
  List<Object> get props => [];
}

class RegisterError extends RegisterState {
  final String error;

  RegisterError(this.error);

  @override
  List<Object> get props => [error];
}
