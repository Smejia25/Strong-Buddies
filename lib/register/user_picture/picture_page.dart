import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.listen((onData) {
      print(onData);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      setState(() {
                        selectedImages = imageSelected;
                      });
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
                      setState(() {
                        picturesTaken = [...picturesTaken, image];
                      });
                    } catch (e) {}
                  }),
              BlocListener<PicturepageBloc, PicturepageState>(
                  bloc: _bloc,
                  listener: (context, state) {
                    // TODO: implement listener
                  }),
              if (selectedImages.isNotEmpty) ...[
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    children: List.generate(
                      selectedImages.length,
                      (index) {
                        Asset asset = selectedImages[index];
                        return AssetThumb(
                          asset: asset,
                          width: 300,
                          height: 300,
                        );
                      },
                    ),
                  ),
                )
              ],
              if (picturesTaken.isNotEmpty) ...[
                Expanded(
                  child: ListView(
                    children: picturesTaken.map(
                      (picture) {
                        print(picture);
                        return Image.file(picture);
                      },
                    ).toList(),
                  ),
                )
              ],
              RaisedButton(
                child: Text('Finish process'),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, Routes.loginPage, (_) => false);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
