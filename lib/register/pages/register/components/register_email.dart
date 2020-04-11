import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/register/pages/register/models/registration_user.dart';
import 'package:strong_buddies_connect/register/pages/register/utils/update_user_util.dart';
import 'package:strong_buddies_connect/shared/utils/form_util.dart';
import 'shared/register_container_wrapper.dart';

class RegisterEmail extends StatefulWidget {
  const RegisterEmail({Key key}) : super(key: key);

  @override
  _RegisterEmailState createState() => _RegisterEmailState();
}

class _RegisterEmailState extends State<RegisterEmail> {
  final RegistrationUser _user = RegistrationUser();
  final _formKey = GlobalKey<FormState>();
  bool _userFound = false;

  @override
  void initState() {
    super.initState();
    getCurrentState(context, (currentState) {
      setState(() {
        _userFound = currentState.userFound;
        _user.email = currentState.user.email;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RegisterContainerWrapper(
      labelForInput:
          _userFound ? 'We already got your email' : 'Please, enter your emai',
      child: Form(
        key: _formKey,
        child: TextFormField(
          key: UniqueKey(),
          autovalidate: true,
          autofocus: true,
          initialValue: _user.email,
          enabled: !_userFound,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(labelText: 'Email'),
          onChanged: (newValue) {
            if (!_formKey.currentState.validate()) return;
            _user.email = newValue;
            updateUserInfo(context, _user);
          },
          validator: (String value) {
            if (value.isEmpty)
              return 'Please, enter your email';
            else if (!FormUtil.isEmailValid(value))
              return 'Please, enter a valid email';
            return null;
          },
        ),
      ),
    );
  }
}
