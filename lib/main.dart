import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strong_buddies_connect/themes/main_theme.dart';
import 'package:strong_buddies_connect/user_info/user_info.dart';

import 'authentication/authentication_page.dart';

void main() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool isLoggedIn = preferences.getBool('isLoggedIn') != null;
  runApp(MyApp(isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp(this.isLoggedIn);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
            value: FirebaseAuth.instance.onAuthStateChanged)
      ],
      child: MaterialApp(
        initialRoute: isLoggedIn ? '/form' : '/',
        routes: {
          '/': (context) => LoginPage(),
          '/form': (context) => UserInfoPage()
        },
        theme: buildAppTheme(),
      ),
    );
  }
}
