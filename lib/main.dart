import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strong_buddies_connect/home/home_page.dart';
import 'package:strong_buddies_connect/routes.dart';
import 'package:strong_buddies_connect/shared/components/matchDialog.dart';
import 'package:strong_buddies_connect/shared/models/current_user_pojo.dart';
import 'package:strong_buddies_connect/shared/services/auth/auth_service.dart';
import 'package:strong_buddies_connect/shared/services/location_service.dart';
import 'package:strong_buddies_connect/shared/services/user_collection.dart';
import 'package:strong_buddies_connect/themes/main_theme.dart';
import 'authentication/login/login_page.dart';
import 'authentication/login_with_phone/login_with_phone.dart';
import 'buddyDetail/buddyDetail.dart';
import 'register/pages/newRegister/register_page.dart';
import 'package:strong_buddies_connect/chatList/chatList.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'shared/models/current_user_notifier.dart';
import 'shared/utils/navigation_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final result = await handleInitialConfig();

  runApp(MaterialApp(
      home: MyApp(startPage: result['route'], user: result['user'])));
}

Future<Map<String, Object>> handleInitialConfig() async {
  final result =
      await Future.wait<dynamic>([askToTurnOnGps(), getInitialPage()]);
  return result[1];
}

Future<void> askToTurnOnGps() async {
  final location = LocationService();
  final auth = AuthService();
  final userRepository = UserCollection();
  final _locationData = await location.getPermissions();
  final user = await auth.getCurrentUser();
  if (user != null)
    await userRepository.updateLocation(user.uid, _locationData.data);
}

Future<Map<String, Object>> getInitialPage() async {
  final auth = AuthService();
  final userRepository = UserCollection();
  final user = await auth.getCurrentUser();

  if (user == null) return {'route': Routes.loginPage};

  final userInfo = await userRepository.getCurrentUserInfo(user.uid);
  return {
    'route': getNavigationRouteBasedOnUserState(userInfo),
    'user': userInfo,
  };
}

class MyApp extends StatefulWidget {
  final String startPage;
  final CurrentUser user;
  const MyApp({startPage: '/', this.user}) : this.startPage = startPage;
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  LocationData currentLocation;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      try {
        final Map<dynamic, dynamic> data = message['data'];
        showDialog(
          context: context,
          builder: (context) {
            return MatchDialog(
              buddy: data,
            );
          },
        );
      } catch (e) {
        print(e);
      }
    }, onLaunch: (Map<String, dynamic> message) async {
      Navigator.pushNamed(context, Routes.chatListPage);
    }, onResume: (Map<String, dynamic> message) async {
      Navigator.pushNamed(context, Routes.chatListPage);
    });
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 812, allowFontScaling: true);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CurrentUserNotifier>(
            create: (_) => CurrentUserNotifier(widget.user))
      ],
      child: MaterialApp(
          initialRoute: this.widget.startPage,
          routes: {
            Routes.loginPage: (context) => LoginPage(),
            Routes.matchPage: (context) => HomePage(),
            Routes.loginPagePhoneNumber: (context) =>
                LoginWithPhoneNumberPage(),
            Routes.registerPage: (context) => RegisterPageNew(),
            Routes.chatListPage: (context) => ChatList(),
            Routes.buddyProfile: (context) => BuddyDetail()
          },
          theme: buildAppTheme()),
    );
  }
}
