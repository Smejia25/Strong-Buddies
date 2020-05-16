import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:strong_buddies_connect/shared/components/tappable_wrapper.dart';
import 'package:strong_buddies_connect/shared/utils/list_utils.dart';

class RegisterPageNew extends StatefulWidget {
  RegisterPageNew({Key key}) : super(key: key);

  @override
  _RegisterPageNewState createState() => _RegisterPageNewState();
}

class _RegisterPageNewState extends State<RegisterPageNew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
          child: Container(
        child: ListView(
          children: <Widget>[UploadPictures()],
        ),
      )),
    );
  }
}

class UploadPictures extends StatefulWidget {
  final void Function(List<Asset>) onChanged;

  const UploadPictures({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  _UploadPicturesState createState() => _UploadPicturesState();
}

class _UploadPicturesState extends State<UploadPictures> {
  final List<Widget> examplePictures = turnListToWidgetList(
      new List(6), (i, _) => Image.asset('example-${i + 1}.jpg'));

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(16),
            vertical: ScreenUtil().setHeight(12),
          ),
          child: Stack(
            children: <Widget>[
              StaggeredGridView.count(
                crossAxisSpacing: ScreenUtil().setWidth(12),
                mainAxisSpacing: ScreenUtil().setHeight(12),
                crossAxisCount: 3,
                primary: false,
                staggeredTiles: [
                  const StaggeredTile.count(2, 2),
                  const StaggeredTile.count(1, 1),
                  const StaggeredTile.count(1, 1),
                  const StaggeredTile.count(1, 1),
                  const StaggeredTile.count(1, 1),
                  const StaggeredTile.count(1, 1),
                ],
                children: examplePictures,
              ),
              Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FaIcon(
                        FontAwesomeIcons.camera,
                        size: ScreenUtil().setSp(36),
                        color: Color(0xff545455),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(14)),
                      Text(
                        'Upload Your\nPictures',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff545455),
                          fontSize: ScreenUtil().setSp(23),
                          height: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(242, 242, 242, 0.9),
                  // border: Border.all(color: Color(0xff555455)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
