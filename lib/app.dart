import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jci_app/core/config/env/providersList.dart';
import 'package:jci_app/core/routes.dart';

import 'package:jci_app/features/auth/presentation/bloc/auth/auth_bloc.dart';

import 'core/config/locale/app__localizations.dart';

import 'features/changelanguages/presentation/bloc/locale_cubit.dart';

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
                    theme: themeData,
                    routerConfig: router(_navigatorKey, widget.text),
                    debugShowCheckedModeBanner: false,
                    title: 'JCI App',
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
