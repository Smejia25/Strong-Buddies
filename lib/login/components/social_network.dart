import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:strong_buddies_connect/login/models/login.state.dart';
import 'package:strong_buddies_connect/shared/services/auth_service.dart';
import '../../routes.dart';

class SocialNetworkLogin extends StatefulWidget {
  final AuthService auth;
  final Subject<LoginStateData> isLoading$;

  const SocialNetworkLogin({Key key, this.auth, this.isLoading$})
      : super(key: key);

  @override
  _SocialNetworkLoginState createState() => _SocialNetworkLoginState();
}

class _SocialNetworkLoginState extends State<SocialNetworkLogin> {
  bool isThereAnotherLoginInProcess = false;

  void _goToNextPage() {
    Navigator.pushNamedAndRemoveUntil(context, Routes.matchPage, (_) => false);
  }

  void _loginWithGoogle(BuildContext context) async {
    widget.isLoading$.add(LoginStateData(LoginState.Unable));
    try {
      await widget.auth.loginWithGoogle();
      widget.isLoading$.add(LoginStateData(LoginState.Ready));
      _goToNextPage();
    } catch (e) {
      _handleErrorInLogin(e.message);
    }
  }

  void _handleErrorInLogin(String errorMessage) {
    if (errorMessage.isNotEmpty)
      widget.isLoading$
          .add(LoginStateData(LoginState.Ready, mesage: errorMessage));
    else
      widget.isLoading$.add(LoginStateData(LoginState.Ready));
  }

  void _loginWithFacebook(BuildContext context) async {
    widget.isLoading$.add(LoginStateData(LoginState.Unable));
    try {
      await widget.auth.loginWithFacebook();
      widget.isLoading$.add(LoginStateData(LoginState.Ready));
      _goToNextPage();
    } catch (e) {
      _handleErrorInLogin(e.message);
    }
  }

  @override
  void initState() {
    super.initState();
    widget.isLoading$.stream.listen((onData) {
      if (onData == null) return;
      setState(() {
        isThereAnotherLoginInProcess = onData.loginState == LoginState.Unable;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
              color: Theme.of(context).accentColor,
              textColor: Theme.of(context).primaryColor,
              onPressed: isThereAnotherLoginInProcess
                  ? null
                  : () => _loginWithGoogle(context),
              child: Text('Google')),
        ),
        SizedBox(width: 12),
        Expanded(
          child: RaisedButton(
            color: Theme.of(context).accentColor,
            textColor: Theme.of(context).primaryColor,
            onPressed: isThereAnotherLoginInProcess
                ? null
                : () => _loginWithFacebook(context),
            child: Text('Facebook'),
          ),
        ),
      ],
    );
  }
}
