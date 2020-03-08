import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:strong_buddies_connect/register/user_data/register_page.dart';
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
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
          value: FirebaseAuth.instance.onAuthStateChanged,
        )
      ],
      child: MaterialApp(
        initialRoute: Routes.loginPage,
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
