import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:strong_buddies_connect/shared/services/auth/auth_service.dart';
import 'package:strong_buddies_connect/shared/services/user_collection.dart';
import 'package:strong_buddies_connect/shared/utils/navigation_util.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService _auth;
  final UserCollection userRespository;
  final FirebaseMessaging _firebaseMessaging;

  LoginBloc(
    this._auth,
    this.userRespository,
    this._firebaseMessaging,
  );

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    Future<AuthResult> loginPromise = _getLoginType(event);
    if (loginPromise == null) return;

    try {
      yield PerformingLoading();
      final userResult = await loginPromise;
      final user =
          await userRespository.getCurrentUserInfo(userResult.user.uid);
      if (user != null) {
        final token = await _firebaseMessaging.getToken();
        await userRespository.updateNotificationTokens(
          token,
          userResult.user.uid,
        );
      }
      final routeToNavigateNext = getNavigationRouteBasedOnUserState(user);
      yield SuccesfulLogin(routeToNavigateNext);
    } catch (e) {
      yield (LoginWithError(_getErrorToShow(e)));
    }
  }

  String _getErrorToShow(Exception error) {
    return error is PlatformException && error.message.isNotEmpty
        ? error.message
        : '';
  }

  Future<AuthResult> _getLoginType(LoginEvent event) {
    if (event is PerformLoginWithGoogle)
      return _auth.loginWithGoogle();
    else if (event is PerformLoginWithFacebook)
      return _auth.loginWithFacebook();
    return null;
  }
}
