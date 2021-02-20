import 'package:flutter/material.dart';
import 'social_network_button.dart';
import 'package:get/get.dart';

import '../login_controller.dart';

class AppleButton extends StatelessWidget {
  final LoginController controller = Get.find();

  final bool loginInProgress;
  final Color color = Colors.black;
  AppleButton({Key key, this.loginInProgress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SocialNetworkButton(
        text: 'Connect with Apple',
        loginInProgress: loginInProgress,
        color: color,
        onPressed: () => controller.loginWithApple());
  }
}
