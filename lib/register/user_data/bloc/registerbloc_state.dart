part of 'registerbloc_bloc.dart';

abstract class RegisterblocState extends Equatable {
  const RegisterblocState();
}

class RegisterblocInitial extends RegisterblocState {
  @override
  List<Object> get props => [];
}

class RegisterInProcess extends RegisterblocState {
  @override
  List<Object> get props => [];
}

class RegisterWithError extends RegisterblocState {
  final String error;

  RegisterWithError(this.error);

  @override
  List<Object> get props => [error];
}

class UserCreated extends RegisterblocState {
  @override
  List<Object> get props => [];
}
