import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  final fontFamily = 'Ubuntu';
  final fontsizeButton = 14.0;

  final primaryColor = Color(0xff5b3c7b);
  final primaryColorDark = Color(0xff2f144e);
  final primaryColorLight = Color(0xff2f144e);
  final secondaryColor = Color(0xffbababa);

  return ThemeData(
    fontFamily: 'Ubuntu',
    textTheme: textTheme(fontFamily, fontsizeButton),
    hintColor: Color(0xff9A88AE),
    focusColor: Color(0xff5b3c7b),
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    primaryColorLight: primaryColorLight,
    accentColor: secondaryColor,
    buttonTheme: ButtonThemeData(
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.accent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)))),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle:
          TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w500),
      fillColor: Colors.white,
      contentPadding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 0),
      filled: true,
      border: UnderlineInputBorder(borderRadius: BorderRadius.circular(6)),
      enabledBorder:
          UnderlineInputBorder(borderRadius: BorderRadius.circular(6)),
      focusedBorder:
          UnderlineInputBorder(borderRadius: BorderRadius.circular(6)),
      errorBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(6)),
    ),
  );
}

TextTheme textTheme(String fontFamily, double fontsizeButton) {
  return TextTheme(
    bodyText1: TextStyle(fontFamily: fontFamily),
    headline3: TextStyle(
      color: Color(0xff4a4a4a),
      fontSize: 20,
      height: 1.2,
      fontWeight: FontWeight.bold,
      letterSpacing: -1,
    ),
    button: TextStyle(
      fontFamily: fontFamily,
      fontSize: fontsizeButton,
      color: Colors.yellow,
    ),
  );
}
