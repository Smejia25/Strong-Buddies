import 'dart:ui';
import 'package:flutter/material.dart';

class RegisterCard extends StatelessWidget {
  final String label;
  final String imageAsset;

  const RegisterCard({
    Key key,
    @required this.label,
    @required this.imageAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: Colors.white,
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: FractionallySizedBox(
                  widthFactor: 0.60,
                  child: Image.asset(imageAsset),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  label,
                  style: TextStyle(color: Colors.black87),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /* @override
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
                      label,
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
  } */
}
