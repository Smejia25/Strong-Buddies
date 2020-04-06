import 'package:flutter/material.dart';
import 'divider_login.dart';

class DividerSection extends StatelessWidget {
  const DividerSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const <Widget>[
        const SizedBox(height: 20),
        const CustomDivider(),
        const SizedBox(height: 30),
      ],
    );
  }
}
