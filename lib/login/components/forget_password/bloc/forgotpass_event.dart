part of 'forgotpass_bloc.dart';

abstract class ForgotpassEvent extends Equatable {
  const ForgotpassEvent();
}

class StartForgetPasswordProcess extends ForgotpassEvent {
  final String email;

  const StartForgetPasswordProcess(this.email);

  @override
  List<Object> get props => [email];
}
