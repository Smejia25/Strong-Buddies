import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:strong_buddies_connect/routes.dart';
import 'package:strong_buddies_connect/shared/components/tappable_wrapper.dart';
import 'package:strong_buddies_connect/shared/services/auth_service.dart';
import 'package:strong_buddies_connect/shared/services/loader_service.dart';
import 'package:strong_buddies_connect/shared/services/user_collection.dart';
import 'package:strong_buddies_connect/shared/services/user_storage.dart';
import 'package:strong_buddies_connect/shared/utils/form_util.dart';
import 'package:strong_buddies_connect/shared/utils/list_utils.dart';

import 'bloc/pictures_bloc.dart';

class PicturesPage extends StatefulWidget {
  PicturesPage({Key key}) : super(key: key);

  @override
  _PicturesPageState createState() => _PicturesPageState();
}

class _PicturesPageState extends State<PicturesPage> {
  List<Asset> _picturesSelectedFromGallery = [];
  int _profilePicture;
  PicturesBloc _bloc;

  Loader _loader;
  @override
  void initState() {
    super.initState();
    _loader = Loader(context);
    _bloc = PicturesBloc(
      AuthService(),
      UserCollection(),
      UserStorage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: const ExactAssetImage('assets/images/background-login.jpg'),
          fit: BoxFit.cover,
        )),
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: BlocListener<PicturesBloc, PicturesState>(
            bloc: _bloc,
            listener: _handleStateChange,
            child: Column(
              children: <Widget>[
                SizedBox(height: 150, child: getProfilePicture()),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50)),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.50),
                          offset: Offset(0, -1),
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                        )
                      ],
                    ),
                    height: double.infinity,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: GridView.count(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                children: turnListToWidgetList<Asset>(
                                    _picturesSelectedFromGallery,
                                    (index, picture) => TappableWrapper(
                                          onTap: () => setState(
                                              () => _profilePicture = index),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              child: AssetThumb(
                                                quality: 100,
                                                asset: picture,
                                                height: 1000,
                                                width: 1000,
                                              ),
                                            ),
                                          ),
                                        )).toList()),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              RaisedButton(
                                onPressed: () async {
                                  try {
                                    final selectedPics =
                                        await MultiImagePicker.pickImages(
                                      maxImages: 10,
                                      enableCamera: true,
                                    );
                                    setState(() {
                                      _picturesSelectedFromGallery =
                                          selectedPics;
                                      _profilePicture = 0;
                                    });
                                  } catch (e) {}
                                },
                                child: Text('Select Pictures'),
                              ),
                              RaisedButton(
                                onPressed:
                                    FormUtil.getFunctionDependingOnEnableState(
                                  _picturesSelectedFromGallery.isEmpty,
                                  () {
                                    _bloc.add(PicturesUploadPictures(
                                        _picturesSelectedFromGallery,
                                        _profilePicture));
                                  },
                                ),
                                child: Text('Update Pictures'),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleStateChange(BuildContext context, PicturesState state) {
    if (state is PicturesUploadeInProgress) {
      _loader.showLoader();
      return;
    }
    _loader.dismissLoader();
    if (state is PicturesUploadWithError)
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.error)));
    else if (state is PicturesUploadedSucessful)
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.matchPage, (_) => false);
  }

  Center getProfilePicture() {
    return _profilePicture != null
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(width: 2, color: Colors.white70)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: AssetThumb(
                    quality: 100,
                    asset: _picturesSelectedFromGallery[_profilePicture],
                    height: 150,
                    width: 150,
                  ),
                ),
              ),
            ),
          )
        : Center();
  }
}
