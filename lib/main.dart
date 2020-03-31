import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/register/pages/register/register_page.dart';

import 'package:strong_buddies_connect/register/user_picture/picture_page.dart';
import 'package:strong_buddies_connect/routes.dart';
import 'package:strong_buddies_connect/shared/services/auth_service.dart';
import 'package:strong_buddies_connect/themes/main_theme.dart';
import 'package:strong_buddies_connect/login/authentication_page.dart';
import 'matching/matching_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String startPage = await getInitialPage();
  runApp(MyApp(startPage));
}

Future<String> getInitialPage() async {
  final auth = AuthService();
  final user = await auth.getCurrentUser();
  return user == null ? Routes.loginPage : Routes.matchPage;
}

class MyApp extends StatelessWidget {
  final String startPage;
  const MyApp(this.startPage);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: Routes.registerPage,
        routes: {
          Routes.loginPage: (context) => LoginPage(),
          Routes.matchPage: (context) => UserInfoPage(),
          Routes.registerPage: (context) => RegisterPage(),
          Routes.picturePage: (context) => PicturePage()
        },
        theme: buildAppTheme());
  }
}
