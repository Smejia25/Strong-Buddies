import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:strong_buddies_connect/shared/services/auth/auth_service.dart';
import 'package:strong_buddies_connect/shared/services/user_collection.dart';
import 'package:strong_buddies_connect/shared/utils/navigation_util.dart';

class LoginController extends GetxController {
  final AuthService _auth = Get.find();
  final UserCollection userRespository = Get.find();
  final FirebaseMessaging _firebaseMessaging = Get.find();

  final void Function(String) onLoginSucessLogin;
  final void Function(String) onFailedLogin;

  var performingLoading = false.obs;

  LoginController({this.onLoginSucessLogin, this.onFailedLogin});

  void performLoginProcess(Future<AuthResult> Function() callback) async {
    performingLoading.value = true;
    try {
      final user = await callback();
      handleLogin(user);
    } on FormatException catch (e) {
      if (e.message != 'Cancelled') onFailedLogin(e.message);
    } catch (e) {
      print(e);
      onFailedLogin('There was a mistake, please try later');
    }
    performingLoading.value = false;
  }

  void handleLogin(AuthResult userResult) async {
    final user = await userRespository.getCurrentUserInfo(userResult.user.uid);
    if (user != null) {
      final token = await _firebaseMessaging.getToken();
      await userRespository.updateNotificationTokens(
        token,
        userResult.user.uid,
      );
    }
    final routeToNavigateNext = getNavigationRouteBasedOnUserState(user);
    onLoginSucessLogin(routeToNavigateNext);
  }

  void loginWithGoogle() {
    this.performLoginProcess(() => _auth.loginWithGoogle());
  }

  void loginWithFacebook() {
    this.performLoginProcess(() => _auth.loginWithFacebook());
  }

  void loginWithApple() {
    this.performLoginProcess(() => _auth.logInWithApple());
  }
}
