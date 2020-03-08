import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:strong_buddies_connect/shared/services/auth_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService _auth;

  LoginBloc(this._auth);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    Future<AuthResult> loginPromise = _getLoginType(event);
    if (loginPromise == null) return;

    try {
      yield PerformingLoading();
      await loginPromise;
      yield SuccesfulLogin();
    } catch (e) {
      yield (LoginWithError(_getErrorToShow(e)));
    }
  }

  String _getErrorToShow(Exception error) {
    return error is PlatformException ? error.message : error.toString();
  }

  Future<AuthResult> _getLoginType(LoginEvent event) {
    Future<AuthResult> loginPromise;

    if (event is PerformLoginWithCredentials)
      loginPromise = _auth.login(event.email, event.password);
    else if (event is PerformLoginWithGoogle)
      loginPromise = _auth.loginWithGoogle();
    else if (event is PerformLoginWithFacebook)
      loginPromise = _auth.loginWithFacebook();

    return loginPromise;
  }
}
