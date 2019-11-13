import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton(
      {Key key, @required this.child, @required this.onPressed})
      : super(key: key);

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Theme.of(context).accentColor,
      textColor: Theme.of(context).primaryColor,
      onPressed: onPressed,
      child: child,
    );
  }
}
