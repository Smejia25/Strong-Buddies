import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  final fontFamily = 'Ubuntu';
  final fontsizeButton = 14.0;

  final primaryColor = Color(0xff5b3c7b);
  final primaryColorDark = Color(0xff2f144e);
  final primaryColorLight = Color(0xff2f144e);
  final secondaryColor = Color(0xffffffff);

  return ThemeData(
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
            borderRadius: BorderRadius.all(Radius.circular(5))),
        height: 45),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle:
          TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w500),
      fillColor: secondaryColor,
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
    body1: TextStyle(fontFamily: fontFamily),
    button: TextStyle(
      fontFamily: fontFamily,
      fontSize: fontsizeButton,
      color: Colors.yellow,
    ),
  );
}
