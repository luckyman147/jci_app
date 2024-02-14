import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:jci_app/features/Home/presentation/pages/Home_page.dart';
import 'package:jci_app/features/auth/presentation/pages/Forget_password_page.dart';
import 'package:jci_app/features/auth/presentation/pages/ResetPasswordPage.dart';
import 'package:jci_app/features/auth/presentation/pages/login_pages.dart';
import 'package:jci_app/features/auth/presentation/pages/pinPage.dart';
import 'package:jci_app/features/changelanguages/presentation/pages/screen.dart';
import 'package:jci_app/features/intro/presentation/bloc/index_bloc.dart';



import '../features/auth/presentation/pages/SignUPPage.dart';
import '../features/intro/presentation/pages/Introduction.dart';
import '../features/intro/presentation/pages/Splash_screen.dart';


GoRouter router(navigatorKey,text)  => GoRouter(
  initialLocation: text ??'/',

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


),GoRoute(
path: '/pin/:email',
builder: (BuildContext context, GoRouterState state) {
  final  email = state.pathParameters['email']! ;

  return Pincode(email: email,);
},


),
GoRoute(
path: '/reset/:email',
builder: (BuildContext context,  state) {
  final  email = state.pathParameters['email']! ;
return ResetPassword(email: email,);
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