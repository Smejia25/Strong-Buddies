import 'package:flutter/material.dart';

class StatusCircle extends StatelessWidget {
  const StatusCircle({Key key, this.size, this.color}) : super(key: key);
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: color, // button color
        child: InkWell(
          splashColor: Colors.red, // inkwell color
          child: SizedBox(
            width: size,
            height: size,
          ),
        ),
      ),
    );
  }
}
