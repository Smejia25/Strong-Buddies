import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/home/home_page.dart';
import 'package:strong_buddies_connect/routes.dart';
import 'package:strong_buddies_connect/shared/services/auth/auth_service.dart';
import 'package:strong_buddies_connect/shared/services/location_service.dart';
import 'package:strong_buddies_connect/shared/services/user_collection.dart';
import 'package:strong_buddies_connect/themes/main_theme.dart';
import 'authentication/login/login_page.dart';
import 'authentication/login_with_phone/login_with_phone.dart';
import 'register/pages/newRegister/register_page.dart';
import 'package:strong_buddies_connect/chatList/chatList.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'shared/utils/navigation_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:strong_buddies_connect/chat/chat.dart';
import 'package:strong_buddies_connect/chat/const.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final startPage = await handleInitialConfig();
  runApp(MaterialApp(
    home: MyApp(startPage: startPage),
    debugShowCheckedModeBanner: false,
  ));
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

class MyApp extends StatefulWidget {
  final String startPage;
  const MyApp({startPage: '/'}) : this.startPage = startPage;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

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
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              contentPadding: EdgeInsets.all(0.0),
              content: Container(
                  height: 400,
                  child: Stack(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20)),
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFFF8960),
                                  const Color(0xFFFF62A5),
                                ],
                                stops: [0.5502, 1],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                              ),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            height: 200,
                            padding: EdgeInsets.only(bottom: 20),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                data['displayName'],
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          )),
                          RaisedButton(
                            color: Color(0xFFFF8960),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.red)),
                            onPressed: () {
                              Navigator.of(context).pop();

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Chat(
                                          peerId: data['documentID'],
                                          peerAvatar: data['photoUrl'],
                                          displayName: data['displayName'])));
                            },
                            child: Text(
                              'Send a message',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          OutlineButton(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.red)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            borderSide: BorderSide(style: BorderStyle.none),
                            child: Text(
                              'Keep looking',
                              style: TextStyle(color: Color(0xffC1C0C9)),
                            ),
                          )
                        ],
                      ),
                      Positioned(
                          top: 50,
                          left: 50,
                          child: Material(
                            child: data['photoUrl'] != null
                                ? CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.0,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                themeColor),
                                      ),
                                      width: 250.0,
                                      height: 250.0,
                                      padding: EdgeInsets.all(15.0),
                                    ),
                                    imageUrl: data['photoUrl'],
                                    width: 180.0,
                                    height: 180.0,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    Icons.account_circle,
                                    size: 50.0,
                                    color: greyColor,
                                  ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100.0)),
                            clipBehavior: Clip.hardEdge,
                          ))
                    ],
                  )),
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
    return MaterialApp(
        initialRoute: this.widget.startPage,
        routes: {
          Routes.loginPage: (context) => LoginPage(),
          Routes.matchPage: (context) => HomePage(),
          Routes.loginPagePhoneNumber: (context) => LoginWithPhoneNumberPage(),
          Routes.registerPage: (context) => RegisterPageNew(),
          Routes.chatListPage: (context) => ChatList()
        },
        theme: buildAppTheme());
  }
}
