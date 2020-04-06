import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/register/pages/register/models/user_pojo.dart';
import 'package:strong_buddies_connect/register/pages/register/utils/update_user_util.dart';
import 'shared/register_container_wrapper.dart';

class RegisterPassword extends StatefulWidget {
  const RegisterPassword({Key key}) : super(key: key);

  @override
  _RegisterPasswordState createState() => _RegisterPasswordState();
}

class _RegisterPasswordState extends State<RegisterPassword> {
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  User _user = User();

  @override
  void initState() {
    super.initState();
    _user = getCurrentUserState(context);
    _passController.text = _user.password;
  }

  @override
  Widget build(BuildContext context) {
    return RegisterContainerWrapper(
      labelForInput: "Please, enter a password",
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _passController,
              autovalidate: true,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please, enter a password';
                } else if (value.length < 6) {
                  return 'The password is too short';
                }
                return null;
              },
            ),
            SizedBox(height: 12),
            TextFormField(
              initialValue: _user.password,
              obscureText: true,
              autovalidate: true,
              onChanged: (newValue) {
                if (newValue.isEmpty || _passController.text != newValue)
                  return;
                _user.password = newValue;
                updateUserInfo(context, _user);
              },
              decoration: InputDecoration(labelText: 'Confirm Password'),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please, enter a password';
                } else if (_passController.text != value) {
                  return 'The passwords do not match';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passController.dispose();
    super.dispose();
  }
}
