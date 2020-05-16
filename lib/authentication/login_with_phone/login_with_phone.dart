import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:strong_buddies_connect/authentication/login/components/login_container.dart';
import 'package:strong_buddies_connect/authentication/login_with_phone/components/code_form.dart';
import 'package:strong_buddies_connect/authentication/login_with_phone/components/phone_form.dart';
import 'package:strong_buddies_connect/shared/services/auth/auth_service.dart';

import 'package:strong_buddies_connect/shared/services/user_collection.dart';
import 'package:strong_buddies_connect/shared/utils/navigation_util.dart';

class LoginWithPhoneNumberPage extends StatefulWidget {
  LoginWithPhoneNumberPage({Key key}) : super(key: key);

  @override
  _LoginWithPhoneNumberPageState createState() =>
      _LoginWithPhoneNumberPageState();
}

class _LoginWithPhoneNumberPageState extends State<LoginWithPhoneNumberPage> {
  final _userRespository = UserCollection();
  final _auth = AuthService();
  final _firebaseMessaging = FirebaseMessaging();
  final _controller = PageController();
  String _verificationId;

  Future<void> handleSucessfulLogin(AuthResult auth) async {
    final user = await _userRespository.getCurrentUserInfo(auth.user.uid);
    if (user != null) {
      final token = await _firebaseMessaging.getToken();
      await _userRespository.updateNotificationTokens(
        token,
        auth.user.uid,
      );
    }
    final routeToNavigateNext = getNavigationRouteBasedOnUserState(user);
    Navigator.pushNamedAndRemoveUntil(
        context, routeToNavigateNext, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return LoginContainer(
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: ScreenUtil().setHeight(20)),
              const Title(),
              SizedBox(height: ScreenUtil().setHeight(40)),
              Expanded(
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _controller,
                  children: <Widget>[
                    PhoneForm(
                        auth: _auth,
                        onSucessfulLogin: handleSucessfulLogin,
                        onCodeSent: (verificationId, [_]) {
                          _verificationId = verificationId;
                          _controller.jumpToPage(1);
                        }),
                    CodeForm(
                        verificationId: _verificationId,
                        onSucessfulLogin: handleSucessfulLogin,
                        auth: _auth)
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class Title extends StatelessWidget {
  const Title({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Login with phone number',
      textAlign: TextAlign.left,
      style: TextStyle(
        color: Colors.white,
        letterSpacing: -1.5,
        height: 1.2,
        fontSize: 25,
      ),
    );
  }
}
