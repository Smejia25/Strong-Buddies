import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/routes.dart';
import 'package:strong_buddies_connect/shared/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff16171b),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(
                    'https://cdn.pixabay.com/photo/2016/11/22/22/24/adult-1850925_960_720.jpg'),
              ),
              const SizedBox(height: 25),
              const Text(
                'Luis Eduardo Palacios Arboleda',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    letterSpacing: 0.4,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    labelText: 'Email',
                    hintText: 'Input your email',
                    hintStyle: TextStyle(color: Color(0xff3f434c)),
                    filled: false,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff3f434c)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff3f434c)),
                    )),
              ),
              RaisedButton(
                  onPressed: () async {
                    final auth = AuthService();
                    await auth.singOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, Routes.loginPage, (_) => false);
                  },
                  child: Text('Sign Out')),
            ],
          ),
        ),
      ),
    );
  }
}
