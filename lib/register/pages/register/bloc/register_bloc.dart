import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:strong_buddies_connect/register/pages/register/models/user_pojo.dart';
import 'package:strong_buddies_connect/shared/services/auth_service.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  User _userInfo = User();
  bool _userFound = false;

  final AuthService _auth;

  RegisterBloc(this._auth);

  @override
  RegisterState get initialState => RegisterInitial(_userInfo, _userFound);

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is RegisterEventUpdateUserData) {
      _userInfo = _userInfo.mergeUserInfo(event.user);
      yield (RegisterDataUpdated(_userInfo, _userFound));
    } else if (event is RegisterEventCreateUser) {
      try {
        yield (RegisterInProcess(_userInfo, _userFound));
        await _auth.registerUser(_userInfo.email, _userInfo.password);
        yield (RegisterSucessful(_userInfo, _userFound));
      } catch (e) {
        yield (RegisterWithError(_userInfo, _userFound,
            e is PlatformException ? e.message : e.toString()));
      }
    } else if (event is RegisterEventGetUserInfo) {
      final currentUser = await _auth.getCurrentUser();
      if (currentUser == null) return;
      _userInfo.email = currentUser.email;
      _userInfo.name = currentUser.displayName;
      _userFound = true;
      yield (RegisterDataUpdated(_userInfo, _userFound));
    }
  }
}
