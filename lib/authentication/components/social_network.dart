import 'package:flutter/material.dart';

import 'package:strong_buddies_connect/authentication/providers/auth_service.dart';
import 'package:strong_buddies_connect/shared/components/secndary_button.dart';

class SocialNetworkLogin extends StatelessWidget {
  SocialNetworkLogin({Key key}) : super(key: key);

  final AuthService _auth = AuthService();

  void _goToHomePage(BuildContext context) {
    Navigator.pushNamed(context, '/form');
  }

  void _loginWithGoogle(BuildContext context) async {
    try {
      await _auth.loginWithGoogle();
      _goToHomePage(context);
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
              'The email associated to this account is already registered in the app')));
    }
  }

  void _loginWithFacebook(BuildContext context) async {
    try {
      await _auth.loginWithFacebook();
      _goToHomePage(context);
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
              'The email associated to this account is already registered in the app')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: SecondaryButton(
            onPressed: () => _loginWithGoogle(context),
            child: Text('Google'),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: SecondaryButton(
            onPressed: () => _loginWithFacebook(context),
            child: Text('Facebook'),
          ),
        ),
      ],
    );
  }
}
