import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:strong_buddies_connect/shared/services/auth_service.dart';
import 'package:strong_buddies_connect/shared/services/user_collection.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService _auth;
  final UserCollection userRespository;

  LoginBloc(this._auth, this.userRespository);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    Future<AuthResult> loginPromise = _getLoginType(event);
    if (loginPromise == null) return;

    try {
      yield PerformingLoading();
      final userResult = await loginPromise;
      yield SuccesfulLogin(await _doesTheAppHaveInfoOnThisUser(userResult));
    } catch (e) {
      yield (LoginWithError(_getErrorToShow(e)));
    }
  }

  Future<bool> _doesTheAppHaveInfoOnThisUser(AuthResult userResult) async =>
      (await userRespository.getUser(userResult.user.email)) != null;

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
