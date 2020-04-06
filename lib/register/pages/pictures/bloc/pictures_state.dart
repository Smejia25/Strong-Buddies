part of 'pictures_bloc.dart';

abstract class PicturesState extends Equatable {
  const PicturesState();
}

class PicturesInitial extends PicturesState {
  const PicturesInitial();

  @override
  List<Object> get props => null;
}

class PicturesUploadWithError extends PicturesState {
  final String error;

  const PicturesUploadWithError(this.error);

  @override
  List<Object> get props => [error];
}

class PicturesUploadedSucessful extends PicturesState {
  const PicturesUploadedSucessful();

  @override
  List<Object> get props => null;
}

class PicturesUploadeInProgress extends PicturesState {
  const PicturesUploadeInProgress();

  @override
  List<Object> get props => null;
}
