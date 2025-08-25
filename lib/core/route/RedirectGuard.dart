
import 'package:auto_route/auto_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LastRouteRedirectGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    final prefs = await SharedPreferences.getInstance();
    final lastRoute = prefs.getString('last_route');

    if (lastRoute != null && lastRoute != resolver.route.path) {
      // Redirect without calling resolver.next()
      router.replacePath(lastRoute);
    } else {
      // Only call resolver.next if no redirection is done

      resolver.next();
    }
  }
}
