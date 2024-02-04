import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/features/auth/domain/repositories/MemberRepository.dart';
import 'package:jci_app/features/auth/presentation/bloc/authentication/authentication_bloc.dart';

import 'core/routes.dart';
import 'features/auth/domain/repositories/Authentication.dart';
import 'features/intro/presentation/bloc/index_bloc.dart';

void main() {
  runApp( MyApp(

  ));
}

class MyApp extends StatefulWidget {

  const MyApp({super.key,   });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int initialIndex = 0;
  late final AuthenticationRepository _authenticationRepository;
  late final MemberRepository _memberRepository;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    initialIndex=0;
    _authenticationRepository = AuthenticationRepository();
    _memberRepository = MemberRepository();
  }

   @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _authenticationRepository.dispose();
  }
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return  RepositoryProvider.value(
      value: _authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          // BlocProvider(create: (context) => AuthBloc(authRepository: AuthRepository())),
          BlocProvider(create: (_)=>IndexBloc( initialIndex)),
          BlocProvider(create: (_)=> AuthenticationBloc(authenticationRepository: _authenticationRepository, memberRepository: _memberRepository))
        ],
        child:
          MaterialApp.router(
            routerConfig: router(_navigatorKey),


            debugShowCheckedModeBanner: false,
            title: 'JCI App',

          ),

      ),
    );
  }
}
