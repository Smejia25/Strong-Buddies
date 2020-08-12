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

/* class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  void handleSuccesfulLogin(BuildContext context, LoginState state) {
    if (state is SuccesfulLogin)
      Navigator.pushNamedAndRemoveUntil(
          context, state.routeToNavigate, (_) => false);
    else if (state is LoginWithError)
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.error)));
  }

  @override
  Widget build(BuildContext context) {
    return LoginContainer(
      child: Container(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 36),
        width: double.infinity,
        child: BlocProvider<LoginBloc>(
          create: (_) =>
              LoginBloc(AuthService(), UserCollection(), FirebaseMessaging()),
          child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, currentState) {
            final isLoading = currentState is PerformingLoading;
            return BlocListener<LoginBloc, LoginState>(
                listener: handleSuccesfulLogin,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setHeight(50)),
                    const ImageLogo(),
                    const Spacer(),
                    PrimaryButton.text(
                      isDisable: isLoading,
                      text: 'Connect with phone number',
                      onTap: () => Navigator.pushNamed(
                        context,
                        Routes.loginPagePhoneNumber,
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    FacebookButton(loginInProgress: isLoading),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    GoogleButton(loginInProgress: isLoading),
                    SizedBox(height: ScreenUtil().setHeight(56)),
                    const TermsAndConditions()
                  ],
                ));
          }),
        ),
      ),
    );
  }
}
 */
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      LoginController(
        onLoginSucessLogin: (route) =>
            Navigator.pushNamedAndRemoveUntil(context, route, (_) => false),
        onFailedLogin: (error) =>
            Scaffold.of(context).showSnackBar(SnackBar(content: Text(error))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoginContainer(
      child: Container(
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
      ),
    );
  }
}
