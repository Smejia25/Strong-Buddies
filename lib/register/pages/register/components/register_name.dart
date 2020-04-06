import 'package:strong_buddies_connect/register/pages/register/models/user_pojo.dart';
import 'package:strong_buddies_connect/register/pages/register/utils/update_user_util.dart';
import 'package:flutter/material.dart';
import 'shared/register_container_wrapper.dart';

class RegisterName extends StatefulWidget {
  const RegisterName({Key key}) : super(key: key);

  @override
  _RegisterNameState createState() => _RegisterNameState();
}

class _RegisterNameState extends State<RegisterName> {
  User _user = User();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _user = getCurrentUserState(context);
  }

  @override
  Widget build(BuildContext context) {
    return RegisterContainerWrapper(
      labelForInput: "Please, enter your name",
      child: Form(
        key: _formKey,
        child: TextFormField(
          initialValue: _user.name,
          autovalidate: true,
          autofocus: true,
          onChanged: (newValue) {
            _user.name = newValue;
            updateUserInfo(context, _user);
          },
          decoration: InputDecoration(labelText: 'Name'),
          validator: (String value) {
            if (value.isEmpty) {
              return 'Please, enter your name';
            }
            return null;
          },
        ),
      ),
    );
  }
}
