import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/features/auth/presentation/pages/login_pages.dart';

import '../features/auth/domain/usecases/Authentication.dart';
import '../features/auth/presentation/bloc/authentication/authentication_bloc.dart';
import '../features/auth/presentation/pages/SignUPPage.dart';
import '../features/intro/presentation/pages/Introduction.dart';
import '../features/intro/presentation/pages/Splash_screen.dart';


 GoRouter router(navigatorKey) => GoRouter(
  navigatorKey:navigatorKey ,
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return SplashScreen();
      },
      redirect: (context, state) {
        final authBloc = context.read<AuthenticationBloc>();
        final authState = authBloc.state;
        switch (authState.status) {
          case AuthenticationStatus.authenticated:
            return '/login';
          case AuthenticationStatus.unauthenticated:
            print('true');
            return '/Intro';
          case AuthenticationStatus.unknown:
            return null;
        }
      },

    ),


    GoRoute(
      path: '/Intro',
      builder: (BuildContext context, GoRouterState state) {
        return IntroductionPage();

      },
    ),
    GoRoute(path: '/login',
      builder: (BuildContext context, GoRouterState state)=>LoginPage(),
    ),GoRoute(path: '/SignUp',
      builder: (BuildContext context, GoRouterState state)=>SignUpPage(),
    )


  ],
);