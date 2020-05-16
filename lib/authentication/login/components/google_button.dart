import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strong_buddies_connect/authentication/login/bloc/login_bloc.dart';
import 'social_network_button.dart';

class GoogleButton extends StatelessWidget {
  final Color color = const Color(0xfffc3850);
  const GoogleButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SocialNetworkButton(
      text: 'Connect with Google',
      color: color,
      onPressed: () => BlocProvider.of<LoginBloc>(context).add(
        PerformLoginWithGoogle(),
      ),
    );
  }
}
