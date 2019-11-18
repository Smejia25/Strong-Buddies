import 'package:flutter/material.dart';

import 'components/authentication_form.dart';
import 'components/divider_login.dart';
import 'components/social_network.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage('assets/images/background-login.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset('assets/images/logo.png'),
                AuthenticationForm(),
                SizedBox(height: 20),
                CustomDivider(),
                SizedBox(height: 25),
                SocialNetworkLogin()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
