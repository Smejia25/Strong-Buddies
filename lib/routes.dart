import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/authentication/authentication_page.dart';
import 'package:strong_buddies_connect/registration/categories.dart';
import 'package:strong_buddies_connect/registration/gender_target.dart';

import 'package:strong_buddies_connect/registration/registration_page.dart';
import 'package:strong_buddies_connect/registration/time_workout.dart';
import 'package:strong_buddies_connect/registration/user_name_page.dart';
import 'package:strong_buddies_connect/user_info/user_info.dart';

Map<String, WidgetBuilder> routes() {
  return {
    // '/': (context) => LoginPage(),
    '/': (context) => UserInfoPage(),
    '/form': (context) => UserInfoPage(),
    '/user_name': (context) => UserNamePage(),
    '/gender_form': (context) => RegistrationPage(),
    '/gender_target_form': (context) => GenderTargetPage(),
    '/categories_form': (context) => CategoriesPage(),
    '/workout_time_form': (context) => WorkoutTimePage(),
  };
}
