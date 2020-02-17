part of 'picturepage_bloc.dart';

abstract class PicturepageEvent extends Equatable {
  const PicturepageEvent();
}

class TakePicture extends PicturepageEvent {
  final File takenPicture;

  const TakePicture(this.takenPicture);

  @override
  List<Object> get props => [takenPicture];
}

class SelectPicturesFromGallery extends PicturepageEvent {
  final List<Asset> selectedImages;

  const SelectPicturesFromGallery(this.selectedImages);

  @override
  List<Object> get props => [selectedImages];
}

class UploadPictures extends PicturepageEvent {
  const UploadPictures();

  @override
  List<Object> get props => null;
}
