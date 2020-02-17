part of 'picturepage_bloc.dart';

abstract class PicturepageState extends Equatable {
  final List<Asset> selectedImages;
  final List<File> picturesTaken;

  const PicturepageState(this.selectedImages, this.picturesTaken);

  @override
  List<Object> get props => [selectedImages, picturesTaken];
}

class PicturepageNormalState extends PicturepageState {
  final List<Asset> selectedImages;
  final List<File> picturesTaken;

  const PicturepageNormalState(this.selectedImages, this.picturesTaken)
      : super(selectedImages, picturesTaken);

  @override
  List<Object> get props => [selectedImages, picturesTaken];
}

class PicturepageUploadingPictures extends PicturepageState {
  final List<Asset> selectedImages;
  final List<File> picturesTaken;

  const PicturepageUploadingPictures(this.selectedImages, this.picturesTaken)
      : super(selectedImages, picturesTaken);

  @override
  List<Object> get props => [selectedImages, picturesTaken];
}

class PicturepagePictureUploaded extends PicturepageState {
  final List<Asset> selectedImages;
  final List<File> picturesTaken;

  const PicturepagePictureUploaded(this.selectedImages, this.picturesTaken)
      : super(selectedImages, picturesTaken);

  @override
  List<Object> get props => [selectedImages, picturesTaken];
}
