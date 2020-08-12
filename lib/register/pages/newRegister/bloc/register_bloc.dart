import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:strong_buddies_connect/register/pages/newRegister/models/registration_user.dart';
import 'package:strong_buddies_connect/shared/services/user_collection.dart';
import 'package:strong_buddies_connect/shared/services/user_storage.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<CreateUser, RegisterState> {
  final FirebaseMessaging _firebaseMessaging;
  final UserCollection _userCollection;
  final UserStorage _userStorage;

  RegisterBloc(
    this._firebaseMessaging,
    this._userCollection,
    this._userStorage,
  );

  @override
  RegisterState get initialState => RegisterInitial();

  @override
  Stream<RegisterState> mapEventToState(CreateUser event) async* {
    yield RegisterInProcess();

    try {
      final user = event.user;
      user.token = await _firebaseMessaging.getToken();
      await _userCollection.setUserInfo(user);
      if (user.uploadedPictures != null) {
        final urlOfUploadedPics = await _userStorage
            .uploadBatchOfImagesInAssetFormat(user.id, user.uploadedPictures);
        await _userCollection.updateUserPictures(user.id, urlOfUploadedPics, 0);
      }

      yield RegisterSucessful();
    } catch (e) {
      yield RegisterError(e.toString());
    }
  }
}
