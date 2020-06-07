import 'package:flutter/material.dart';

class MatchButton extends StatelessWidget {
  const MatchButton({
    Key key,
    this.onPressed,
    this.icon,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Icon icon;
  final _size = 60.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,      
      height: _size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_size),
        child: Material(
          elevation: 2,
          shape: CircleBorder(),
          color: Colors.white,
          child: IconButton(
            icon: icon,
            iconSize: 35,
            padding: EdgeInsets.zero,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
