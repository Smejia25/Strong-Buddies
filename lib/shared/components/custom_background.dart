import 'package:flutter/material.dart';

class CustomBackground extends StatelessWidget {
  const CustomBackground({
    Key key,
    @required this.child,
    @required this.backgroundColor,
    @required this.backgroundImage,
  }) : super(key: key);

  final Widget child;
  final Color backgroundColor;
  final String backgroundImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              color: backgroundColor,
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.25,
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: ExactAssetImage(
                              backgroundImage /* 'assets/images/background-login.jpg' */),
                          fit: BoxFit.cover))),
            ),
          ),
          Positioned.fill(child: child)
        ],
      ),
    );
  }
}
