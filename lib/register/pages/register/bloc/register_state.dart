part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  final RegistrationUser user;
  final bool userFound;
  const RegisterState(this.user, this.userFound);

  List<Object> get props => [user, userFound];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial(RegistrationUser user, bool userFound)
      : super(user, userFound);
}

class RegisterInitialUserInfo extends RegisterState {
  const RegisterInitialUserInfo(RegistrationUser user, bool userFound)
      : super(user, userFound);
}

class RegisterInProcess extends RegisterState {
  const RegisterInProcess(RegistrationUser user, bool userFound)
      : super(user, userFound);
}

class RegisterDataUpdated extends RegisterState {
  const RegisterDataUpdated(
    RegistrationUser user,
    bool userFound,
  ) : super(user, userFound);
}

class RegisterWithError extends RegisterState {
  final String error;

  const RegisterWithError(
    RegistrationUser user,
    bool userFound,
    this.error,
  ) : super(user, userFound);

  List<Object> get props => [user, userFound, error];
}

class RegisterSucessful extends RegisterState {
  const RegisterSucessful(
    RegistrationUser user,
    bool userFound,
  ) : super(user, userFound);
}

class RegisterCanceled extends RegisterState {
  const RegisterCanceled(RegistrationUser user, bool userFound)
      : super(user, userFound);
}
