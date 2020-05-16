import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:strong_buddies_connect/shared/services/auth/auth_service.dart';
import 'package:strong_buddies_connect/shared/services/user_collection.dart';
import 'package:strong_buddies_connect/shared/services/user_storage.dart';

part 'pictures_event.dart';
part 'pictures_state.dart';

class PicturesBloc extends Bloc<PicturesUploadPictures, PicturesState> {
  final AuthService _auth;
  final UserCollection _userCollection;
  final UserStorage userStorage;

  PicturesBloc(this._auth, this._userCollection, this.userStorage);

  @override
  PicturesState get initialState => PicturesInitial();

  @override
  Stream<PicturesState> mapEventToState(
    PicturesUploadPictures event,
  ) async* {
    yield (PicturesUploadeInProgress());

    try {
      final userId = (await _auth.getCurrentUser()).uid;
      final urlOfUploadedPics =
          await userStorage.uploadBatchOfImagesInAssetFormat(
        userId,
        event.picturesSelectedFromGallery,
      );
      await _userCollection.updateUserPictures(userId, urlOfUploadedPics, event.profilePictureFromUploadedPictures);
      yield (PicturesUploadedSucessful());
    } catch (e) {
      yield (PicturesUploadWithError(e.toString()));
    }
  }
}
