import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/register/pages/register/register_page.dart';
import 'package:strong_buddies_connect/routes.dart';
import 'package:strong_buddies_connect/shared/services/auth_service.dart';
import 'package:strong_buddies_connect/shared/services/location_service.dart';
import 'package:strong_buddies_connect/shared/services/user_collection.dart';
import 'package:strong_buddies_connect/themes/main_theme.dart';
import 'package:strong_buddies_connect/login/authentication_page.dart';
import 'register/pages/pictures/pictures_page.dart';
import 'matching/matching_page.dart';
import 'shared/utils/navigation_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final startPage = await handleInitialConfig();
  runApp(MyApp(startPage: startPage));
}

Future<String> handleInitialConfig() async {
  final result =
      await Future.wait<dynamic>([askToTurnOnGps(), getInitialPage()]);
  return result[1];
}

Future<void> askToTurnOnGps() async {
  final location = LocationService();
  return location.handlePermissions();
}

Future<String> getInitialPage() async {
  final auth = AuthService();
  final userRepository = UserCollection();
  final user = await auth.getCurrentUser();
  if (user == null) return Routes.loginPage;
  final userInfo = await userRepository.getCurrentUserInfo(user.uid);

  return getNavigationRouteBasedOnUserState(userInfo);
}

class MyApp extends StatelessWidget {
  final String startPage;
  const MyApp({startPage: '/'}) : this.startPage = startPage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: this.startPage,
        routes: {
          Routes.matchPage: (context) => UserInfoPage(),
          Routes.loginPage: (context) => LoginPage(),
          Routes.registerPage: (context) => RegisterPage(),
          Routes.picturePage: (context) => PicturesPage()
        },
        theme: buildAppTheme());
  }
}
