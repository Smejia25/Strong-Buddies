import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strong_buddies_connect/authentication/providers/auth_service.dart';
import 'package:strong_buddies_connect/registration/registration_page.dart';

class UserInfoPage extends StatefulWidget {
  UserInfoPage({Key key}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RegistrationBackground(
          childcolumn: Column(
        children: <Widget>[
          Expanded(
              child: Container(
            child: Align(
              widthFactor: 1,
              alignment: Alignment.bottomLeft,
              child: Container(
                width: double.infinity,
                height: 80,
                child: Card(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Lindsay, 26',
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ))
        ],
      )),
    );
  }
}
