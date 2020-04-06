import 'package:flutter/material.dart';

class ExplainInput extends StatelessWidget {
  final String reason;

  const ExplainInput({
    Key key,
    this.reason,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      reason,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        color: Color(0xffcecece),
      ),
    );
  }
}
