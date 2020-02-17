part of 'registerbloc_bloc.dart';

abstract class RegisterblocEvent extends Equatable {
  const RegisterblocEvent();
}

class CreateUserEvent extends RegisterblocEvent {
  final RegisterUser user;

  const CreateUserEvent(this.user);

  @override
  List<Object> get props => [user];
}
