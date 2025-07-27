
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/Home/Activity_Global.dart';

class MyRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  Future<void> _saveLastRoute(String routeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_route', routeName);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute && route.settings.name != null) {
      _saveLastRoute(route.settings.name!);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && previousRoute.settings.name != null) {
      _saveLastRoute(previousRoute.settings.name!);
    }
  }
}