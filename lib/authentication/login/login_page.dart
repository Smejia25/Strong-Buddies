import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:strong_buddies_connect/authentication/login/components/google_button.dart';
import 'package:strong_buddies_connect/routes.dart';

import 'package:strong_buddies_connect/shared/components/primary_button.dart';
import 'package:strong_buddies_connect/shared/services/auth/auth_service.dart';
import 'package:strong_buddies_connect/shared/services/user_collection.dart';

import 'bloc/login_bloc.dart';
import 'components/facebook_button.dart';
import 'components/login_container.dart';
import 'components/logo.dart';
import 'components/terms_conditions.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  void _handleSuccesfulLogin(BuildContext context, LoginState state) {
    if (state is SuccesfulLogin)
      Navigator.pushNamedAndRemoveUntil(
          context, state.routeToNavigate, (_) => false);
    else if (state is LoginWithError) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoginContainer(
      child: Container(
        padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(30),
          right: ScreenUtil().setWidth(30),
          bottom: ScreenUtil().setHeight(36),
        ),
        width: double.infinity,
        child: BlocProvider<LoginBloc>(
          create: (BuildContext context) => LoginBloc(
            AuthService(),
            UserCollection(),
            FirebaseMessaging(),
          ),
          child: BlocListener<LoginBloc, LoginState>(
            listener: _handleSuccesfulLogin,
            child: Builder(
              builder: (context) => Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: ScreenUtil().setHeight(50)),
                  const ImageLogo(),
                  const Spacer(),
                  PrimaryButton.text(
                    text: 'Connect with phone number',
                    onTap: () => Navigator.pushNamed(
                      context,
                      Routes.loginPagePhoneNumber,
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(20)),
                  const FacebookButton(),
                  SizedBox(height: ScreenUtil().setHeight(20)),
                  const GoogleButton(),
                  SizedBox(height: ScreenUtil().setHeight(56)),
                  const TermsAndConditions()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
