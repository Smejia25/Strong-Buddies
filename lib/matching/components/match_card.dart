import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:strong_buddies_connect/shared/models/buddy_pojo.dart';
import 'package:strong_buddies_connect/shared/utils/list_utils.dart';

import '../../routes.dart';
import 'match_button.dart';

class MatchCard extends StatelessWidget {
  final Buddy potentialMatch;
  final void Function(Buddy) onMatch;
  final void Function(Buddy) onReject;

  const MatchCard({
    Key key,
    @required this.potentialMatch,
    @required this.onMatch,
    @required this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(13),
                  topRight: Radius.circular(13),
                ),
                child: Hero(
                  tag: 'images',
                  child: PictureCarousel(pictures: potentialMatch.pictures),
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(113.3),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () async {
                            final result = await Navigator.pushNamed(
                              context,
                              Routes.buddyProfile,
                              arguments: potentialMatch,
                            );
                            switch (result) {
                              case true:
                                onMatch(potentialMatch);
                                break;
                              case false:
                                onReject(potentialMatch);
                                break;
                              default:
                            }
                          },
                          child: Hero(
                            tag: 'displayNameProperty',
                            child: Text(
                              potentialMatch.displayName ?? '',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(20),
                                  color: Color(0xff4A4A4A),
                                  letterSpacing: 0.225882),
                            ),
                          )),
                      SizedBox(height: ScreenUtil().setHeight(6)),
                      Hero(
                        tag: 'inCommon',
                        child: Text('Colombia, Medellín',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(15),
                                color: Color(0xffC1C0C9),
                                letterSpacing: -0.36)),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(20)),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Transform.translate(
                      offset: Offset(0, -30),
                      child: Hero(
                        tag: 'matchButtons',
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            MatchButton(
                              onPressed: () => onReject(potentialMatch),
                              icon: Icon(
                                Icons.close,
                                color: Color(0xffC1C0C9),
                              ),
                            ),
                            SizedBox(width: ScreenUtil().setWidth(30)),
                            MatchButton(
                              onPressed: () => onMatch(potentialMatch),
                              icon: Icon(
                                Icons.favorite,
                                color: Color(0xffFF8960),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        color: Colors.white);
  }
}

class PictureCarousel extends StatefulWidget {
  final List<String> pictures;
  const PictureCarousel({
    Key key,
    this.pictures = const [],
  }) : super(key: key);

  @override
  _PictureCarouselState createState() => _PictureCarouselState();
}

class _PictureCarouselState extends State<PictureCarousel> {
  int imageBeingShown = 0;
  List<Image> images = [];

  @override
  void initState() {
    super.initState();
    if (widget.pictures != null)
      images = widget.pictures
          .map((e) => Image.network(e, fit: BoxFit.cover))
          .toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    images.forEach((element) => precacheImage(element.image, context));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        PageView.builder(
          onPageChanged: (index) => setState(() => imageBeingShown = index),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) =>
              Image.network(widget.pictures[index], fit: BoxFit.cover),
          itemCount: widget.pictures != null ? widget.pictures.length : 0,
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 15),
            child: Column(
              children: widget.pictures == null
                  ? []
                  : turnListToWidgetList<String>(
                      widget.pictures,
                      (i, picture) {
                        return Container(
                          width: 8,
                          height: 8,
                          margin: EdgeInsetsDirectional.only(bottom: 5.25),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: imageBeingShown == i
                                  ? Colors.white
                                  : Colors.white30),
                        );
                      },
                    ),
            ),
          ),
        )
      ],
    );
  }
}
