import 'package:flutter/material.dart';

import 'divider_login.dart';

class DividerSection extends StatelessWidget {
  const DividerSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        CustomDivider(),
        SizedBox(height: 30),
      ],
    );
  }
}
