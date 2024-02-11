import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';

import 'package:jci_app/core/widgets/loading_widget.dart';

import '../../../auth/presentation/bloc/auth/auth_bloc.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {

        // TODO: implement listener
      },
      builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (state is AuthFailureState) {
            context.go('/Intro'); // Redirect to login if token refresh fails
          } else if (state is AuthSuccessState) {
            context.go('/home'); // Redirect to home if token refresh succeeds
          } else {
            context.go('/login'); // Redirect to intro if token refresh succeeds
          }
        });

        return Container(
            decoration: BoxDecoration(color: backgroundColored),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Expanded(child: Center(
                      child: Image.asset("assets/images/jci.png",
                          width: 250, height: 250, fit: BoxFit.contain))),

                  LoadingWidget()
                ],
              ),
            ));
      },
    );
  }
}
