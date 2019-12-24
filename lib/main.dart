import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:strong_buddies_connect/routes.dart';
import 'package:strong_buddies_connect/themes/main_theme.dart';
import 'package:strong_buddies_connect/user_info/user_info.dart';

import 'authentication/authentication_page.dart';

void main() async => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
            value: FirebaseAuth.instance.onAuthStateChanged)
      ],
      child: MaterialApp(
        initialRoute: Routes.loginPage,
        routes: {
          Routes.loginPage: (context) => LoginPage(),
          Routes.matchPage: (context) => UserInfoPage()
        },
        theme: buildAppTheme(),
      ),
    );
  }
}
