import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:strong_buddies_connect/register/user_data/register_page.dart';
import 'package:strong_buddies_connect/register/user_picture/picture_page.dart';
import 'package:strong_buddies_connect/routes.dart';
import 'package:strong_buddies_connect/themes/main_theme.dart';
import 'package:strong_buddies_connect/user_info/user_info.dart';
import 'package:strong_buddies_connect/login/authentication_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
          value: FirebaseAuth.instance.onAuthStateChanged,
        )
      ],
      child: MaterialApp(
        initialRoute: Routes.registerPage,
        routes: {
          Routes.loginPage: (context) => LoginPage(),
          Routes.matchPage: (context) => UserInfoPage(),
          Routes.registerPage: (context) => RegisterPage(),
          Routes.picturePage: (context) => PicturePage()
        },
        theme: buildAppTheme(),
      ),
    );
  }
}
