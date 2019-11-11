import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import 'package:strong_buddies_connect/authentication/providers/auth_service.dart';
import 'package:validate/validate.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({
    Key key,
    @required AuthService auth,
  })  : _auth = auth,
        super(key: key);

  final _formKeyForDialog = GlobalKey<FormState>();
  final TextEditingController _textFieldController = TextEditingController();
  final AuthService _auth;

  String _emailValidator(value) {
    if (value.isEmpty) return 'Please, enter your email';
    try {
      Validate.isEmail(value);
      return null;
    } catch (e) {
      return 'Please, enter a valid email';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () {
            final PublishSubject<bool> dialogAnswer$ =
                new PublishSubject<bool>();

            dialogAnswer$.stream.take(1).listen((usersSelection) =>
                Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(usersSelection
                        ? 'Please, check your email to continue the process'
                        : 'There is not a user with your email'))));

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Forgot password'),
                content: Form(
                  key: _formKeyForDialog,
                  child: TextFormField(
                    validator: _emailValidator,
                    controller: _textFieldController,
                    decoration: InputDecoration(labelText: "Enter your email"),
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: new Text(
                      'Cancel',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    textColor: Colors.white,
                    child: Text('Submit'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    onPressed: () async {
                      if (!_formKeyForDialog.currentState.validate()) {
                        return;
                      }
                      bool wasProcessSucessful = true;
                      try {
                        await _auth.forgetPassword(_textFieldController.text);
                      } catch (e) {
                        wasProcessSucessful = false;
                      }
                      dialogAnswer$.add(wasProcessSucessful);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text('Forgot the password?',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.w500)),
          ),
        ),
      ),
    );
  }
}
