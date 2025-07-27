import 'package:auto_route/auto_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jci_app/core/config/env/providersList.dart';
import 'package:jci_app/core/route/app_router.dart';

import 'package:jci_app/features/auth/presentation/bloc/auth/auth_bloc.dart';

import 'core/config/locale/app__localizations.dart';

import 'core/config/services/NotificationService/NotificationService.dart';
import 'core/route/status/status_cubit.dart';
import 'features/changelanguages/presentation/bloc/locale_cubit.dart';
import 'injection_container.dart' as di;
import 'core/app_theme.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatefulWidget {
  final String? text;

  const MyApp({
    super.key,
    this.text,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int initialIndex = 0;

  @override
  void initState() {
    FirebaseMessaging.instance.requestPermission();

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        if (message.data['end_time'] != null) {
          NotificationService.showCountUpNotification(message);
        } else {
          NotificationService.showNotification(message);
        }
      }
    });

    // Handle notifications tapped while the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['route'] != null) {

      }
    });
    super.initState();
    // TODO: implement initState
    initialIndex = 0;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  final _navigatorKey = GlobalKey<NavigatorState>();
  final appRouter = di.sll<AppRouter>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      splitScreenMode: true,
      minTextAdapt: true,
      child: MultiBlocProvider(
        providers: providersList,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return BlocBuilder<localeCubit, LocaleState>(
              buildWhen: (previous, current) => previous != current,
              builder: (context, state) {
                if (state is ChangeLocalState) {
                  return MaterialApp.router(
                    scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
                    theme: themeData,
                    routerConfig:  appRouter.config(
                      reevaluateListenable: ReevaluateListenable.stream(
                        di.sll<StatusCubit>().stream,
                      ),
                    ),

                    debugShowCheckedModeBanner: false,
                    title: 'JCI OC',
                    supportedLocales: const [
                      Locale('en', 'US'),
                      Locale('fr', 'FR'),
                    ],
                    localizationsDelegates: [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate
                    ],
                    localeResolutionCallback: (locale, supportedLocales) {
                      for (var supported in supportedLocales) {
                        if (locale != null &&
                            locale.languageCode == supported.languageCode) {
                          return locale;
                        }
                      }
                      return supportedLocales.first;
                    },
                    locale: state.locale,
                  );
                }
                return const SizedBox();
              },
            );
          },
        ),
      ),
    );
  }
}
