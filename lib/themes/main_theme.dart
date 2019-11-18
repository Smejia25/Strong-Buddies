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
    hintColor: /* Color(0xffaa8ec5) */ Colors.grey,
    focusColor: Colors.green,
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    primaryColorLight: primaryColorLight,
    accentColor: secondaryColor,
    brightness: Brightness.dark,
    buttonTheme: ButtonThemeData(
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.accent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      height: 45,
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(
        fontSize: 18,
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
        color: Colors.grey,
      ),
      contentPadding: EdgeInsets.all(15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
          width: 2.5,
        ),
        gapPadding: 7,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
          width: 2.5,
        ),
        gapPadding: 7,
      ),
    ),
  );
}

TextTheme textTheme(String fontFamily, double fontsizeButton) {
  return TextTheme(
    body1: TextStyle(fontFamily: fontFamily),
    button: TextStyle(
        fontFamily: fontFamily, fontSize: fontsizeButton, color: Colors.yellow),
  );
}
