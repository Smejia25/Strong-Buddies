import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/shared/models/current_user_pojo.dart';

class CurrentUserNotifier extends ChangeNotifier {
  CurrentUser _user;
  CurrentUserNotifier(this._user);

  CurrentUser get user => _user;
  set user(CurrentUser user) {
    _user = user;
    notifyListeners();
  }
}
