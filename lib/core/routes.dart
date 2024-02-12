import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/features/Home/presentation/pages/Home_page.dart';
import 'package:jci_app/features/auth/presentation/pages/Forget_password_page.dart';
import 'package:jci_app/features/auth/presentation/pages/login_pages.dart';
import 'package:jci_app/features/changelanguages/presentation/pages/screen.dart';


import '../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../features/auth/presentation/pages/SignUPPage.dart';
import '../features/intro/presentation/pages/Introduction.dart';
import '../features/intro/presentation/pages/Splash_screen.dart';


GoRouter router(navigatorKey) => GoRouter(
  initialLocation: '/',

  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return SplashScreen();
      },
    ),
GoRoute(
path: '/forget',
builder: (BuildContext context, GoRouterState state) {
return ForgetPasswordPage();
},


),


GoRoute(
      path: '/Intro',
      builder: (BuildContext context, GoRouterState state) {
        return IntroductionPage();

      },
    ),GoRoute(
      path: '/screen',
      builder: (BuildContext context, GoRouterState state) {
        return SettingsPage();

      },
    ),
    GoRoute(path: '/home',
      builder: (BuildContext context, GoRouterState state)=>HomePage(),


    ),
    GoRoute(path: '/login',
      builder: (BuildContext context, GoRouterState state)=>LoginPage(),
    ),GoRoute(path: '/SignUp',
      builder: (BuildContext context, GoRouterState state)=>SignUpPage(),
    )


  ],
);