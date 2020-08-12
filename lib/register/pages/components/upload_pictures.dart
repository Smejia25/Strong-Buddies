import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:strong_buddies_connect/shared/components/primary_button.dart';

class UploadPictures extends StatefulWidget {
  final void Function(List) onChanged;
  final bool isEditingExistingProfile;
  final List<String> pictures;

  const UploadPictures({
    Key key,
    this.onChanged,
    this.isEditingExistingProfile,
    this.pictures,
  }) : super(key: key);

  @override
  _UploadPicturesState createState() => _UploadPicturesState();
}

class _UploadPicturesState extends State<UploadPictures> {
  final _maxPicturesToSelect = 6;
  List _userPictures = [];

  @override
  void initState() {
    super.initState();
    _userPictures = widget.pictures != null ? [...widget.pictures] : [];
  }

  List<dynamic> _getImagesWithPlaceholders() {
    final List<Widget> tempList = [];
    final blankSpaceWidget = DottedBorder(
      radius: Radius.circular(6),
      borderType: BorderType.RRect,
      padding: EdgeInsets.zero,
      color: Colors.grey,
      strokeWidth: 2,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    for (var i = 0; i < _maxPicturesToSelect; i++) {
      try {
        final temp = _userPictures[i];
        Widget widgetToAdd = Container();
        if (temp is Asset) {
          widgetToAdd = AssetThumb(
            quality: 100,
            asset: temp,
            height: 1000,
            width: 1000,
          );
        } else {
          widgetToAdd = Image.network(temp, fit: BoxFit.cover);
        }
        final widgetToRender = Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: widgetToAdd,
              ),
            ),
            Positioned(
              bottom: -3,
              right: -3,
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xffff8960), shape: BoxShape.circle),
                width: 20,
                height: 20,
                child: Center(
                  child: Text(
                    '${i + 1}',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: ScreenUtil().setSp(11)),
                  ),
                ),
              ),
            ),
            Positioned(
              right: -3,
              top: -3,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Removing a picture'),
                      content:
                          Text('Are you sure you want to remove this picture?'),
                      actions: [
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() => _userPictures.removeAt(i));
                              widget.onChanged(_userPictures);
                            },
                            child: Text(
                              'Remove it',
                              style: TextStyle(color: Colors.redAccent),
                            )),
                        FlatButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Cancel'))
                      ],
                    ),
                  );
                },
                child: Container(
                  decoration:
                      BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  width: 20,
                  height: 20,
                  child: Center(
                    child: Text(
                      'x',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: ScreenUtil().setSp(13)),
                    ),
                  ),
                ),
              ),
            )
          ],
        );

        tempList.add(
          DragTarget<int>(
            onAccept: (data) {
              final temp = _userPictures[i];
              setState(() {
                _userPictures[i] = _userPictures[data];
                _userPictures[data] = temp;
              });
              widget.onChanged(_userPictures);
            },
            builder: (_, __, ___) => Draggable<int>(
              data: i,
              childWhenDragging: blankSpaceWidget,
              feedback: Container(
                child: widgetToRender,
                width: 120,
                height: 120,
              ),
              child: widgetToRender,
            ),
          ),
        );
      } catch (e) {
        tempList.add(blankSpaceWidget);
      }
    }
    return tempList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  child: StaggeredGridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
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
                    children: _getImagesWithPlaceholders(),
                  )),
            ),
          ),
        ),
        FractionallySizedBox(
          widthFactor: 0.85,
          child: Column(
            children: [
              PrimaryButton.text(
                text: 'Add more pictures',
                onTap: () async {
                  final maxAmountOfPicturesTheUserCanUpload =
                      _maxPicturesToSelect - _userPictures.length;

                  if (maxAmountOfPicturesTheUserCanUpload == 0) {
                    return Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('You already have 6 pictures.'),
                      ),
                    );
                  }

                  try {
                    final pictures = await MultiImagePicker.pickImages(
                      maxImages: maxAmountOfPicturesTheUserCanUpload,
                      enableCamera: true,
                    );
                    setState(
                        () => _userPictures = [..._userPictures, ...pictures]);
                    widget.onChanged(_userPictures);
                  } catch (e) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Tha app may not have been granted access to gallery'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(20)),
      ],
    );
  }
}
