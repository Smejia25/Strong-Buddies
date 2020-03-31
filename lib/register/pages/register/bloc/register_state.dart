part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  final User user;
  final bool userFound;
  const RegisterState(this.user, this.userFound);

  List<Object> get props => [user, userFound];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial(User user, bool userFound) : super(user, userFound);
}

class RegisterInProcess extends RegisterState {
  const RegisterInProcess(User user, bool userFound) : super(user, userFound);
}

class RegisterDataUpdated extends RegisterState {
  const RegisterDataUpdated(User user, bool userFound) : super(user, userFound);
}

class RegisterWithError extends RegisterState {
  final String error;

  const RegisterWithError(User user, bool userFound, this.error)
      : super(user, userFound);

  List<Object> get props => [user, userFound, error];
}

class RegisterSucessful extends RegisterState {
  const RegisterSucessful(User user, bool userFound) : super(user, userFound);
}
