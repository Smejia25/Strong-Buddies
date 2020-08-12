import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'social_network_button.dart';
import '../login_controller.dart';

class GoogleButton extends StatelessWidget {
  final LoginController controller = Get.find();

  final bool loginInProgress;
  final Color color = const Color(0xfffc3850);
  GoogleButton({Key key, this.loginInProgress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SocialNetworkButton(
        text: 'Connect with Google',
        loginInProgress: loginInProgress,
        color: color,
        onPressed: () => controller.loginWithGoogle());
  }
}
