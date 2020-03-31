import 'package:flutter/material.dart';

class TappableWrapper extends StatelessWidget {
  const TappableWrapper({Key key, this.child, this.onTap}) : super(key: key);
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onTap,
        child: child,
      ),
    );
  }
}
