import 'package:flutter/material.dart';

import 'register_explain.dart';
import 'register_salute.dart';

class RegisterContainerWrapper extends StatelessWidget {
  const RegisterContainerWrapper({
    Key key,
    @required this.child,
    @required this.labelForInput,
  }) : super(key: key);

  final Widget child;
  final String labelForInput;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 5 / 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Salute(),
                const SizedBox(height: 20),
                ExplainInput(reason: labelForInput),
                const SizedBox(height: 35),
                child
              ],
            ),
          ),
        ),
      ),
    );
  }
}
