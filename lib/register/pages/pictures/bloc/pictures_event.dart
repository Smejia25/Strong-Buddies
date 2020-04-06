part of 'pictures_bloc.dart';

class PicturesUploadPictures extends Equatable {
  final List<Asset> picturesSelectedFromGallery;
  final Asset profilePicture;

  const PicturesUploadPictures(
    this.picturesSelectedFromGallery,
    this.profilePicture,
  );

  @override
  List<Object> get props => [picturesSelectedFromGallery, profilePicture];
}
