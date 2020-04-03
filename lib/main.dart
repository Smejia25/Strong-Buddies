import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/register/pages/register/register_page.dart';

import 'package:strong_buddies_connect/register/user_picture/picture_page.dart';
import 'package:strong_buddies_connect/routes.dart';
import 'package:strong_buddies_connect/shared/services/auth_service.dart';
import 'package:strong_buddies_connect/shared/services/location_service.dart';
import 'package:strong_buddies_connect/themes/main_theme.dart';
import 'package:strong_buddies_connect/login/authentication_page.dart';
import 'package:strong_buddies_connect/chatList/chatList.dart';

import 'matching/matching_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await askToTurnOnGps();
  final startPage = await getInitialPage();
  runApp(MyApp(startPage));
}

Future<void> askToTurnOnGps() async {
  final location = LocationService();
  return location.handlePermissions();
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
        initialRoute: this.startPage,
        routes: {
          Routes.loginPage: (context) => LoginPage(),
          Routes.matchPage: (context) => UserInfoPage(),
          Routes.registerPage: (context) => RegisterPage(),
          Routes.picturePage: (context) => PicturePage(),
          Routes.chatListPage: (context) => ChatList()
        },
        theme: buildAppTheme());
  }
}
