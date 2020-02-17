import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strong_buddies_connect/shared/services/auth_service.dart';


import '../routes.dart';

class UserInfoPage extends StatefulWidget {
  UserInfoPage({Key key}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (user != null) ...[
            Text(
              user.email,
              style: TextStyle(fontSize: 50),
            ),
          ],
          RaisedButton(
              onPressed: () async {
                await _auth.singOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.loginPage, (r) => false);
              },
              child: Text(
                'Log Out',
                style: TextStyle(fontSize: 50),
              ))
        ],
      ),
    );
  }
}
