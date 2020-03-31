import 'package:flutter/material.dart';

import 'register_explain.dart';
import 'register_salute.dart';

class RegisterContainerWrapper extends StatelessWidget {
  const RegisterContainerWrapper({
    Key key,
    @required this.child,
    @required this.reason,
  }) : super(key: key);

  final Widget child;
  final String reason;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 5 / 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Salute(),
                  const SizedBox(height: 30),
                  child,
                  const SizedBox(height: 30),
                  ExplainInput(reason: reason)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
