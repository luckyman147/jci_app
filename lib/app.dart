import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jci_app/features/auth/presentation/bloc/auth/auth_bloc.dart';

import 'core/config/locale/app__localizations.dart';


import 'features/changelanguages/presentation/bloc/locale_cubit.dart';
import 'injection_container.dart' as di;
import 'core/app_theme.dart';
import 'core/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


import 'features/auth/presentation/bloc/bool/toggle_bool_bloc.dart';
import 'features/auth/presentation/bloc/login/login_bloc.dart';
import 'features/auth/presentation/bloc/sign_up_bloc.dart';
import 'features/intro/presentation/bloc/index_bloc.dart';

class MyApp extends StatefulWidget {

  const MyApp({
    super.key,
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=>di.sl<AuthBloc>()..add(RefreshTokenEvent())),
        BlocProvider(create: (_) => di.sl<SignUpBloc>()),
        BlocProvider(create: (_) => di.sl<LoginBloc>()),
        BlocProvider(create: (_) => localeCubit()..getSavedLanguage()),

        BlocProvider(create: (_) => ToggleBooleanBloc(initialValue: true)),
        // BlocProvider(create: (context) => AuthBloc(authRepository: AuthRepository())),
        BlocProvider(create: (_) => IndexBloc(initialIndex)),
      ],
      child: BlocBuilder<localeCubit, LocaleState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {

if (state is ChangeLocalState) {
          return MaterialApp.router(
            theme: themeData,
            routerConfig: router(_navigatorKey),
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
          );}
return SizedBox();
        },
      ),
    );
  }
}
