import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/authentication/models/user.dart';
import 'package:strong_buddies_connect/authentication/providers/auth_service.dart';
import 'package:strong_buddies_connect/shared/components/secndary_button.dart';
import 'package:validate/validate.dart';

import 'forgot_pass.dart';

class AuthenticationForm extends StatefulWidget {
  const AuthenticationForm({
    Key key,
  }) : super(key: key);

  @override
  _AuthenticationFormState createState() => _AuthenticationFormState();
}

class _AuthenticationFormState extends State<AuthenticationForm> {
  final AuthService _auth = AuthService();
  final TextEditingController _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final userForm = User();

  bool _isInLogin = true;

  void _goToHomePage(BuildContext context) {
    Navigator.pushNamed(context, '/form');
  }

  void _doLogin() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    Navigator.of(context).pushNamed('/form');

    /*   if (!_isInLogin) {
      try {
        await _auth.registerUser(userForm.email, userForm.password);
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
                'We just sent you a verification email. Check your email')));
      } catch (e) {
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('The email is already registered in the app')));
      }
    } else {
      try {
        await _auth.login(userForm.email, userForm.password);
        _goToHomePage(context);
      } catch (e) {}
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
              'User is not register in the app or the email is not verified')));
    } */
  }

  void _changeAuthType(BuildContext context) {
    // setState(() => _isInLogin = !_isInLogin);
    Navigator.of(context).pushNamed('/user_name');
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

  String _confirmPasswordValidator(value) {
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
  Widget build(BuildContext context) {
    final spaceBetweenInputs = 15.0;
    var text = Text(_isInLogin ? 'Sign Up' : 'Sign In');
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
          SizedBox(height: spaceBetweenInputs),
          if (!_isInLogin) ...[
            TextFormField(
              obscureText: true,
              validator: _confirmPasswordValidator,
              decoration: InputDecoration(labelText: 'Confirm Password'),
            ),
            SizedBox(height: spaceBetweenInputs),
          ],
          Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                    onPressed: _doLogin,
                    child: Text(_isInLogin ? 'Sign In' : 'Sign Up')),
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(child: SecondaryButton(
                child: Text('Sign Up'),
                onPressed: () {
                  Navigator.of(context).pushNamed('/user_name');
                },
              )),
            ],
          ),
          if (_isInLogin) ...[ForgotPassword(auth: _auth)],
        ],
      ),
    );
  }
}
