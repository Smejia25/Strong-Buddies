import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strong_buddies_connect/login/bloc/login_bloc.dart';
import 'package:strong_buddies_connect/routes.dart';
import 'package:strong_buddies_connect/shared/services/auth_service.dart';
import 'package:strong_buddies_connect/shared/services/user_collection.dart';
import 'components/authentication_form.dart';
import 'components/divider_section.dart';
import 'components/social_network.dart';

class LoginPage extends StatelessWidget {
  void _handleSuccesfulLogin(BuildContext context, LoginState state) {
    if (state is SuccesfulLogin)
      Navigator.pushNamedAndRemoveUntil(
          context,
          state.wasUserInfoFound ? Routes.matchPage : Routes.registerPage,
          (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: const ExactAssetImage('assets/images/background-login.jpg'),
          fit: BoxFit.cover,
        )),
        child: SafeArea(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: BlocProvider(
                create: (BuildContext context) =>
                    LoginBloc(AuthService(), UserCollection()),
                child: BlocListener<LoginBloc, LoginState>(
                  listener: _handleSuccesfulLogin,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FractionallySizedBox(
                          widthFactor: 0.65,
                          child: Image.asset('assets/images/logo.png')),
                      AuthenticationForm(),
                      const DividerSection(),
                      const SocialNetworkLogin(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
