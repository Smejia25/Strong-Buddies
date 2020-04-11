import 'package:strong_buddies_connect/routes.dart';
import 'package:strong_buddies_connect/shared/models/current_user_pojo.dart';

String getNavigationRouteBasedOnUserState(CurrentUser user) {
  if (user == null)
    return Routes.registerPage;
  else if (user.pictures == null)
    return Routes.picturePage;
  else
    return Routes.matchPage;
}
