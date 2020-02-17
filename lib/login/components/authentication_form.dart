import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:strong_buddies_connect/login/models/login.state.dart';
import 'package:strong_buddies_connect/login/models/user.dart';

import 'package:strong_buddies_connect/routes.dart';
import 'package:strong_buddies_connect/shared/services/auth_service.dart';
import 'package:validate/validate.dart';

import 'forgot_pass.dart';

class AuthenticationForm extends StatefulWidget {
  const AuthenticationForm({
    Key key,
    this.auth,
    this.isLoading$,
  }) : super(key: key);

  final AuthService auth;
  final Subject<LoginStateData> isLoading$;

  @override
  _AuthenticationFormState createState() => _AuthenticationFormState();
}

class _AuthenticationFormState extends State<AuthenticationForm> {
  final TextEditingController _passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final userForm = User();
  StreamSubscription _streamSubscription;

  bool anAuthProcessIsCurrentlyBeingExecuted = false;

  void _doLogin() async {
    if (!_formKey.currentState.validate()) return;

    widget.isLoading$.add(LoginStateData(LoginState.Unable));
    _formKey.currentState.save();

    try {
      await widget.auth.login(userForm.email, userForm.password);
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.matchPage, (_) => false);
    } on PlatformException catch (e) {
      widget.isLoading$
          .add(LoginStateData(LoginState.Ready, mesage: e.message));
    } catch (e) {
      print(e);
    }
  }

  void _goToRegisterPage() {
    Navigator.pushNamed(context, Routes.registerPage);
  }

  String _emalValidator(String value) {
    if (value.isEmpty) return 'Please, enter a valid email';
    try {
      Validate.isEmail(value);
    } catch (e) {
      return 'Enter a valid email';
    }
    return null;
  }

  String _confirmPasswordValidator(String value) {
    if (value.isEmpty)
      return 'Please, enter your password';
    else if (_passController.text != value) {
      return 'The passwords are not the same';
    }
    return null;
  }

  String _passwordValidator(String value) {
    if (value.isEmpty)
      return 'Please, enter your password';
    else if (value.length < 5) return 'The password is too short';
    return null;
  }

  @override
  void initState() {
    super.initState();
    _streamSubscription = widget.isLoading$.listen((data) {
      if (data == null) return;
      setState(() {
        anAuthProcessIsCurrentlyBeingExecuted =
            data.loginState == LoginState.Unable;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spaceBetweenInputs = 15.0;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            onSaved: (val) => userForm.email = val,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: 'Email'),
            validator: _emalValidator,
          ),
          SizedBox(height: spaceBetweenInputs),
          TextFormField(
            controller: _passController,
            onSaved: (val) => userForm.password = val,
            obscureText: true,
            validator: _passwordValidator,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          StreamBuilder<LoginStateData>(
              stream: widget.isLoading$,
              builder: (context, snapshot) {
                final widgetToShow = snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data.message.isNotEmpty
                    ? Column(
                        children: <Widget>[
                          SizedBox(height: spaceBetweenInputs),
                          Text(
                            snapshot.data.message,
                            style: TextStyle(
                              color: Color(0xffC11616),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    : Center();
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: widgetToShow,
                );
              }),
          SizedBox(height: spaceBetweenInputs),
          /* if (!_isInLogin) ...[
            TextFormField(
              obscureText: true,
              validator: _confirmPasswordValidator,
              decoration: InputDecoration(labelText: 'Confirm Password'),
            ),
            SizedBox(height: spaceBetweenInputs),
          ], */

          /*    StreamBuilder<bool>(
            stream: widget.isLoading$,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ),
                      )
                    : Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              onPressed: _doLogin,
                              child: Text('Sign In'),
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: RaisedButton(
                              color: Theme.of(context).accentColor,
                              textColor: Theme.of(context).primaryColor,
                              onPressed: () => setState(() {
                                // _isInLogin = !_isInLogin;
                              }),
                              child: Text('Sign Up'),
                            ),
                          ),
                        ],
                      );
              }*/
          Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  onPressed:
                      !anAuthProcessIsCurrentlyBeingExecuted ? _doLogin : null,
                  child: Text('Sign In'),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: RaisedButton(
                  color: Theme.of(context).accentColor,
                  textColor: Theme.of(context).primaryColor,
                  onPressed: !anAuthProcessIsCurrentlyBeingExecuted
                      ? _goToRegisterPage
                      : null,
                  child: Text('Sign Up'),
                ),
              ),
            ],
          ),
          ForgotPassword(auth: widget.auth),
        ],
      ),
    );
  }
}
