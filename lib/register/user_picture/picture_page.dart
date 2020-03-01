import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:strong_buddies_connect/register/user_picture/bloc/picturepage_bloc.dart';
import 'package:strong_buddies_connect/routes.dart';

class PicturePage extends StatefulWidget {
  PicturePage({Key key}) : super(key: key);

  @override
  _PicturePageState createState() => _PicturePageState();
}

class _PicturePageState extends State<PicturePage> {
  List<Asset> selectedImages = [];
  List<File> picturesTaken = [];

  final _bloc = PicturepageBloc();
  ProgressDialog _pr;

  StreamSubscription<PicturepageState> _stream;

  @override
  void initState() {
    super.initState();
    _stream = _bloc.listen((state) {
      if (state is PicturepagePictureUploaded) {
        if (_pr != null && _pr.isShowing()) _pr.dismiss();
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.matchPage, (_) => false);
      }
      if (state is PicturepageUploadingPictures) {
        if (_pr != null) _pr.show();
      }
    });
  }

  @override
  void dispose() {
    _stream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    _pr = ProgressDialog(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: <Widget>[
              RaisedButton(
                  child: Text('Select picture'),
                  onPressed: () async {
                    try {
                      final imageSelected = await MultiImagePicker.pickImages(
                        maxImages: 10,
                        enableCamera: true,
                      );
                      _bloc.add(SelectPicturesFromGallery(imageSelected));
                    } catch (e) {
                      print(e.toString());
                    }
                  }),
              RaisedButton(
                  child: Text('take picture'),
                  onPressed: () async {
                    try {
                      final image = await ImagePicker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 100,
                      );
                      if (image == null) return;
                      _bloc.add(TakePicture(image));
                    } catch (e) {}
                  }),
              BlocBuilder<PicturepageBloc, PicturepageState>(
                bloc: _bloc,
                builder: (context, state) {
                  return Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      children: [
                        ...state.picturesTaken
                            .map((picture) => Image.file(picture))
                            .toList(),
                        ...state.selectedImages
                            .map((selectedImage) => AssetThumb(
                                  quality: 100,
                                  asset: selectedImage,
                                  height: 1000,
                                  width: 1000,
                                ))
                            .toList()
                      ],
                    ),
                  );
                },
              ),
              RaisedButton(
                child: Container(
                  child: Text('Finish process', textAlign: TextAlign.center),
                  width: double.infinity,
                ),
                onPressed: () => _bloc.add(UploadPictures(user.email)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
