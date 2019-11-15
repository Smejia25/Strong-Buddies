import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/authentication/providers/auth_service.dart';

class SocialNetworkLogin extends StatelessWidget {
  final AuthService auth;

  SocialNetworkLogin({Key key, this.auth}) : super(key: key);

  void _goToHomePage(BuildContext context) {
    Navigator.pushNamed(context, '/form');
  }

  void _loginWithGoogle(BuildContext context) async {
    try {
      await auth.loginWithGoogle();
      _goToHomePage(context);
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
              'The email associated to this account is already registered in the app')));
    }
  }

  void _loginWithFacebook(BuildContext context) async {
    try {
      await auth.loginWithFacebook();
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
          child: RaisedButton(
              color: Theme.of(context).accentColor,
              textColor: Theme.of(context).primaryColor,
              onPressed: () => _loginWithGoogle(context),
              child: Text('Google')),
        ),
        SizedBox(
          width: 12,
        ),
        Expanded(
          child: RaisedButton(
            color: Theme.of(context).accentColor,
            textColor: Theme.of(context).primaryColor,
            onPressed: () => _loginWithFacebook(context),
            child: Text('Facebook'),
          ),
        ),
      ],
    );
  }
}
