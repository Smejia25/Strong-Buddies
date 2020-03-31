import 'package:flutter/material.dart';

List<Widget> turnListToWidgetList<T>(
  List<T> list,
  Widget Function(int index, T value) callBack,
) {
  return list
      .asMap()
      .map((index, value) => MapEntry(index, callBack(index, value)))
      .values
      .toList();
}
