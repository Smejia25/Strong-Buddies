import 'dart:ui';
import 'package:flutter/material.dart';

class RegisterCard extends StatelessWidget {
  final String workoutTimeText;
  final String imageAsset;

  const RegisterCard({
    Key key,
    @required this.workoutTimeText,
    @required this.imageAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage(imageAsset)),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              child: Stack(
                children: <Widget>[
                  Positioned(
                      bottom: 0,
                      height: 100,
                      width: 100,
                      child: BackdropFilter(
                          child: Container(color: Colors.black.withOpacity(0)),
                          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2))),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      workoutTimeText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
