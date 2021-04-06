import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/chat/const.dart';

class CircleImage extends StatelessWidget {
  const CircleImage(
      {Key key, this.heigth, this.width, this.imageUrl, this.radius})
      : super(key: key);

  final double heigth;
  final double width;
  final String imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: imageUrl != null
          ? CachedNetworkImage(
              placeholder: (context, url) => Container(
                child: CircularProgressIndicator(
                  strokeWidth: 1.0,
                  valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                ),
                width: width,
                height: heigth,
                padding: EdgeInsets.all(15.0),
              ),
              imageUrl: imageUrl,
              width: width,
              height: heigth,
              fit: BoxFit.cover,
            )
          : Icon(
              Icons.account_circle,
              size: width,
              color: Colors.grey,
            ),
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      clipBehavior: Clip.hardEdge,
    );
  }
}
