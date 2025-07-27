import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/route/app_router.dart';
import 'package:jci_app/core/route/status/status_cubit.dart';

class StatusGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {

    final context = resolver.context;
    final statusCubit = context.read<StatusCubit>();

    // If we haven't checked status yet, do it now
    if (statusCubit.state.status == RouteStatus.Initial) {
      await statusCubit.checkAuthStatus();
    }

    // Handle the current status
    switch (statusCubit.state.status) {
      case RouteStatus.Language:
        resolver.next(true); // Allow navigation
        router.replaceAll([const LanguageRoute()]);

        break;
      case RouteStatus.Authenticated:
        resolver.next(true); // Allow navigation
        router.replaceAll([const HomeRoute()]);

        break;
      case RouteStatus.IsFirstEntry:
        resolver.next(false);
        router.replaceAll([const IntroductionRoute()]);
        break;
      case RouteStatus.TokenExpired:
        resolver.next(false);
        router.replaceAll([const LoginRoute()]);
        break;
      case RouteStatus.IsAnonym:
      case RouteStatus.Error:
      case RouteStatus.Initial:
        resolver.next(false);


        router.replaceAll([const SplashRoute()]);
        await statusCubit.checkAuthStatus();
        break;
    }
  }
}