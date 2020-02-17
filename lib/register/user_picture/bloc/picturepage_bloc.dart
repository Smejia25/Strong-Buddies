import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:strong_buddies_connect/shared/services/user_storage.dart';

part 'picturepage_event.dart';
part 'picturepage_state.dart';

class PicturepageBloc extends Bloc<PicturepageEvent, PicturepageState> {
  final _user = UserStorage();

  @override
  PicturepageState get initialState => PicturepageNormalState([], []);

  @override
  Stream<PicturepageState> mapEventToState(
    PicturepageEvent event,
  ) async* {
    if (event is TakePicture) {
      yield PicturepageNormalState(
          state.selectedImages, [...state.picturesTaken, event.takenPicture]);
    }
    if (event is SelectPicturesFromGallery) {
      yield PicturepageNormalState(event.selectedImages, state.picturesTaken);
    }
  }
}
