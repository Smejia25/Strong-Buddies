part of 'forgotpass_bloc.dart';

abstract class ForgotpassState extends Equatable {
  const ForgotpassState();
}

class ForgotpassInitial extends ForgotpassState {
  @override
  List<Object> get props => [];
}

class ForgotpassInProcess extends ForgotpassState {
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
  @override
  List<Object> get props => [];
}
