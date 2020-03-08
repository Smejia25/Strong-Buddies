import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strong_buddies_connect/login/bloc/login_bloc.dart';
import 'package:strong_buddies_connect/shared/services/auth_service.dart';
import 'components/authentication_form.dart';
import 'components/divider_section.dart';
import 'components/social_network.dart';

class LoginPage extends StatelessWidget {
  final backgroundLoginImage = 'assets/images/background-login.jpg';
  final logoImage = 'assets/images/logo.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage(backgroundLoginImage),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: BlocProvider(
                create: (BuildContext context) => LoginBloc(AuthService()),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FractionallySizedBox(
                      widthFactor: 0.75,
                      child: Image.asset(logoImage),
                    ),
                    AuthenticationForm(),
                    const DividerSection(),
                    SocialNetworkLogin(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
