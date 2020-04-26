part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class RegisterEventGetUserInfo extends RegisterEvent {
  const RegisterEventGetUserInfo();

  @override
  List<Object> get props => [];
}

class RegisterEventUpdateUserData extends RegisterEvent {
  final RegistrationUser user;

  const RegisterEventUpdateUserData(this.user);

  @override
  List<Object> get props => [user];
}

class RegisterEventCreateUser extends RegisterEvent {
  const RegisterEventCreateUser();

  @override
  List<Object> get props => [];
}

class RegisterEventCancelRegister extends RegisterEvent {
  const RegisterEventCancelRegister();

  @override
  List<Object> get props => [];
}
