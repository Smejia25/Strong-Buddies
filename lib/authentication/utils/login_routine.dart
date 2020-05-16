import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:strong_buddies_connect/shared/services/user_collection.dart';
import 'package:strong_buddies_connect/shared/utils/navigation_util.dart';

Future<String> handleLogin(
  UserCollection userReposiory,
  FirebaseMessaging firebaseMessaging,
  AuthResult result,
) async {
  final uid = result.user.uid;
  final user = await userReposiory.getCurrentUserInfo(uid);
  if (user != null) {
    final token = await firebaseMessaging.getToken();
    await userReposiory.updateNotificationTokens(token, uid);
  }
  final routeToNavigateNext = getNavigationRouteBasedOnUserState(user);
  return routeToNavigateNext;
}
