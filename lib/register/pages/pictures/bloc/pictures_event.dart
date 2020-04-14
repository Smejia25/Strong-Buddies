part of 'pictures_bloc.dart';

class PicturesUploadPictures extends Equatable {
  final List<Asset> picturesSelectedFromGallery;
  final int profilePictureFromUploadedPictures;

  const PicturesUploadPictures(
    this.picturesSelectedFromGallery,
    this.profilePictureFromUploadedPictures,
  );

  @override
  List<Object> get props => [picturesSelectedFromGallery, profilePictureFromUploadedPictures];
}
