import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:strong_buddies_connect/shared/services/auth_service.dart';
import 'components/authentication_form.dart';
import 'components/divider_section.dart';
import 'components/social_network.dart';
import 'models/login.state.dart';

class LoginPage extends StatelessWidget {
  final AuthService _auth = AuthService();
  final BehaviorSubject<LoginStateData> loginState$ =
      BehaviorSubject<LoginStateData>.seeded(LoginStateData(LoginState.Ready));

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FractionallySizedBox(
                    widthFactor: 0.75,
                    child: Image.asset(logoImage),
                  ),
                  AuthenticationForm(
                    auth: _auth,
                    isLoading$: loginState$,
                  ),
                  const DividerSection(),
                  SocialNetworkLogin(
                    auth: _auth,
                    isLoading$: loginState$,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
