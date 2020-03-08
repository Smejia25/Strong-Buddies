import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:strong_buddies_connect/shared/services/auth_service.dart';

part 'forgotpass_event.dart';
part 'forgotpass_state.dart';

class ForgotpassBloc extends Bloc<ForgotpassEvent, ForgotpassState> {
  final AuthService _auth;

  ForgotpassBloc(this._auth);

  @override
  ForgotpassState get initialState => ForgotpassInitial();

  @override
  Stream<ForgotpassState> mapEventToState(
    ForgotpassEvent event,
  ) async* {
    if ((event is StartForgetPasswordProcess)) {
      yield ForgotpassInProcess();
      try {
        await _auth.forgetPassword(event.email);
        yield ForgotpassProcessFinished();
      } catch (e) {
        yield ForgotpassWithError(
            e is PlatformException ? e.message : e.toString());
      }
    }
  }
}
