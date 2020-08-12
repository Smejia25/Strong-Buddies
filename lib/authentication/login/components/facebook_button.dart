import 'package:flutter/material.dart';
import 'social_network_button.dart';
import 'package:get/get.dart';

import '../login_controller.dart';

class FacebookButton extends StatelessWidget {
  final LoginController controller = Get.find();

  final bool loginInProgress;
  final Color color = const Color(0xff2672CB);
  FacebookButton({Key key, this.loginInProgress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SocialNetworkButton(
        text: 'Connect with Facebook',
        loginInProgress: loginInProgress,
        color: color,
        onPressed: () => controller.loginWithFacebook());
  }
}
