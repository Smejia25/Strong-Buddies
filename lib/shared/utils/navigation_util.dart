import 'package:strong_buddies_connect/routes.dart';
import 'package:strong_buddies_connect/shared/models/current_user_pojo.dart';

String getNavigationRouteBasedOnUserState(CurrentUser user) {
  if (user == null)
    return Routes.registerPage; 
  else
    return Routes.matchPage;
}
