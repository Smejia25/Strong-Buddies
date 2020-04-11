import 'package:strong_buddies_connect/register/pages/register/models/registration_user.dart';
import 'package:strong_buddies_connect/register/pages/register/utils/update_user_util.dart';
import 'package:flutter/material.dart';
import 'shared/register_container_wrapper.dart';

class DisplayName extends StatefulWidget {
  const DisplayName({Key key}) : super(key: key);

  @override
  _DisplayNameState createState() => _DisplayNameState();
}

class _DisplayNameState extends State<DisplayName> {
  final _user = RegistrationUser();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _user.displayName = getCurrentUserState(context).displayName;
  }

  @override
  Widget build(BuildContext context) {
    return RegisterContainerWrapper(
      labelForInput: "Please, enter your public name",
      child: Form(
        key: _formKey,
        child: TextFormField(
          initialValue: _user.displayName,
          autovalidate: true,
          autofocus: true,
          onChanged: (newValue) {
            _user.displayName = newValue;
            updateUserInfo(context, _user);
          },
          decoration: InputDecoration(labelText: 'Public Name'),
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
