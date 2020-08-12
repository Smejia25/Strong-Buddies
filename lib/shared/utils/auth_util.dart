import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strong_buddies_connect/shared/models/current_user_notifier.dart';
import 'package:strong_buddies_connect/shared/services/user_collection.dart';

void setUserInStorage(BuildContext context, String userId) async {
  final userRespository = UserCollection();
  final userInfo = await userRespository.getCurrentUserInfo(userId);
  final userNotifier = Provider.of<CurrentUserNotifier>(context, listen: false);
  userNotifier.user = userInfo;
}
