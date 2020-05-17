part of 'register_bloc.dart';

class CreateUser extends Equatable {
  final RegistrationUser user;

  const CreateUser(this.user);

  @override
  List<Object> get props => [user];
}
