import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:strong_buddies_connect/authentication/login/components/google_button.dart';
import 'package:strong_buddies_connect/routes.dart';
import 'package:strong_buddies_connect/shared/components/primary_button.dart';
import 'login_controller.dart';
import 'components/facebook_button.dart';
import 'components/login_container.dart';
import 'components/logo.dart';
import 'components/terms_conditions.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginContainer(
      child: Builder(builder: (context) {
        final LoginController controller = Get.put(LoginController(
            onLoginSucessLogin: (route) =>
                Navigator.pushNamedAndRemoveUntil(context, route, (_) => false),
            onFailedLogin: (error) => Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text(error)))));
        return Container(
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 36),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: ScreenUtil().setHeight(50)),
              const ImageLogo(),
              const Spacer(),
              Obx(
                () => PrimaryButton.text(
                  isDisable: controller.performingLoading.value,
                  text: 'Connect with phone number',
                  onTap: () => Navigator.pushNamed(
                    context,
                    Routes.loginPagePhoneNumber,
                  ),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),
              Obx(() => FacebookButton(
                  loginInProgress: controller.performingLoading.value)),
              SizedBox(height: ScreenUtil().setHeight(20)),
              Obx(() => GoogleButton(
                  loginInProgress: controller.performingLoading.value)),
              SizedBox(height: ScreenUtil().setHeight(56)),
              const TermsAndConditions()
            ],
          ),
        );
      }),
    );
  }
}
