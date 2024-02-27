import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ACtivityOfweek/activity_ofweek_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/acivity_f_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/bloc/ChangeString/change_string_bloc.dart';



import 'package:jci_app/features/Home/presentation/bloc/PageIndex/page_index_bloc.dart';

import 'package:jci_app/features/auth/presentation/bloc/ResetPassword/reset_bloc.dart';

import 'package:jci_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:jci_app/features/intro/presentation/bloc/bools/bools_bloc.dart';
import 'package:jci_app/features/intro/presentation/bloc/internet/internet_bloc.dart';

import 'core/config/locale/app__localizations.dart';


import 'features/Home/presentation/bloc/DescriptionBoolean/description_bool_bloc.dart';
import 'features/changelanguages/presentation/bloc/locale_cubit.dart';
import 'injection_container.dart' as di;
import 'core/app_theme.dart';
import 'core/routes.dart';

import 'package:flutter_localizations/flutter_localizations.dart';


import 'features/auth/presentation/bloc/bool/toggle_bool_bloc.dart';
import 'features/auth/presentation/bloc/login/login_bloc.dart';
import 'features/auth/presentation/bloc/SignUp/sign_up_bloc.dart';
import 'features/intro/presentation/bloc/index_bloc.dart';

class MyApp extends StatefulWidget {
  final String? text;
  const MyApp({
    super.key, this.text,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int initialIndex = 0;

  @override
  void initState()  {
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

        BlocProvider(create: (_)=> di.sl<AcivityFBloc>()..add(const GetActivitiesOfMonthEvent(act: activity.Events))),
        BlocProvider(create: (_)=> di.sl<ActivityOfweekBloc>()..add(const GetOfWeekActivitiesEvent(act: activity.Events))),

        BlocProvider(create: (_)=> InternetCubit()..CheckConnection()),
        BlocProvider(create: (_)=>di.sl<ResetBloc>()),
        BlocProvider(create: (_)=>di.sl<AuthBloc>()..add(const RefreshTokenEvent())),
        BlocProvider(create: (_) => di.sl<SignUpBloc>()),
        BlocProvider(create: (_) => di.sl<LoginBloc>()),
        BlocProvider(create: (_) => localeCubit()..getSavedLanguage()),
        BlocProvider(create: (_)=>ActivityCubit()),

        BlocProvider(create: (_) => ToggleBooleanBloc(initialValue: true)),
        BlocProvider(create: (_) => DescriptionBoolBloc()),
        BlocProvider(create: (_) => ChangeStringBloc("Events")),
        BlocProvider(create: (_) => PageIndexBloc(0)),
       BlocProvider(create: (_)=> BoolBloc()..add(resetEvent())),
        BlocProvider(create: (_) => IndexBloc(initialIndex)),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(

  builder: (context, state) {

    return BlocBuilder<localeCubit, LocaleState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {

if (state is ChangeLocalState) {
          return MaterialApp.router (
            theme: themeData,
            routerConfig:  router(_navigatorKey,widget.text),
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
return const SizedBox();
        },
      );
  },
),
    );
  }
}
