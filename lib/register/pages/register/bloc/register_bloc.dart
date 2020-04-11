import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:strong_buddies_connect/register/pages/register/models/registration_user.dart';
import 'package:strong_buddies_connect/shared/services/auth_service.dart';
import 'package:strong_buddies_connect/shared/services/user_collection.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthService _auth;
  final UserCollection _userCollection;

  RegistrationUser _userInfo = RegistrationUser()
    ..targetGender = ['Woman', 'Man', 'Other'];
  bool _userFound = false;

  RegisterBloc(this._auth, this._userCollection);

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
        if (!_userFound)
          await _auth.registerUser(_userInfo.email, _userInfo.password);
        _userInfo.id = (await _auth.getCurrentUser()).uid;
        await _userCollection.setUserInfo(_userInfo);
        yield (RegisterSucessful(_userInfo, _userFound));
      } catch (e) {
        yield (RegisterWithError(_userInfo, _userFound,
            e is PlatformException ? e.message : e.toString()));
      }
    } else if (event is RegisterEventGetUserInfo) {
      final currentUser = await _auth.getCurrentUser();

      if (currentUser != null) {
        _userInfo.email = currentUser.email;
        _userInfo.name = _userInfo.displayName = currentUser.displayName;
        _userFound = true;
      }

      yield (RegisterInitialUserInfo(_userInfo, _userFound));
    }
  }
}
