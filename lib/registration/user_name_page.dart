import 'package:flutter/material.dart';

import 'providers/user.dart';
import 'registration_page.dart';

class UserNamePage extends StatefulWidget {
  UserNamePage({Key key}) : super(key: key);

  @override
  _UserNamePageState createState() => _UserNamePageState();
}

class _UserNamePageState extends State<UserNamePage> {
  final _userService = CreateUserFactory();
  final _formKey = GlobalKey<FormState>();
  final _lastNameController = TextEditingController();

  String userName;
  FocusNode _myFocusNode;

  @override
  void initState() {
    super.initState();

    _myFocusNode = FocusNode();
    _myFocusNode.addListener(() {
      setState(() {
        if (!_myFocusNode.hasFocus && _formKey.currentState.validate()) {
          userName = _lastNameController.value.text;
          _userService.assignName(_lastNameController.value.text);
        } else {
          userName = '';
        }
      });
    });
  }

  @override
  void dispose() {
    _myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RegistrationBackground(
        childcolumn: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 80),
            LabelForSelection(
              label: 'Please, fill your name',
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: _lastNameController,
                      focusNode: _myFocusNode,
                      autofocus: true,
                      decoration: InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please, enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            NavigationButtons(
              canNavigationBeDone: userName != null && userName.isNotEmpty,
              continueBtnText: 'Next',
              routeName: '/gender_form',
            ),
          ],
        ),
      ),
    );
  }
}
