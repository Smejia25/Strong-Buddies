part of 'forgotpass_bloc.dart';

abstract class ForgotpassState extends Equatable {
  const ForgotpassState();
}

class ForgotpassInitial extends ForgotpassState {
  const ForgotpassInitial();

  @override
  List<Object> get props => [];
}

class ForgotpassInProcess extends ForgotpassState {
  const ForgotpassInProcess();

  @override
  List<Object> get props => [];
}

class ForgotpassWithError extends ForgotpassState {
  final String error;

  const ForgotpassWithError(this.error);

  @override
  List<Object> get props => [error];
}

class ForgotpassProcessFinished extends ForgotpassState {
  const ForgotpassProcessFinished();

  @override
  List<Object> get props => [];
}
