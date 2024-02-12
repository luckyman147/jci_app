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
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  void _navigateAfterDelay() async {
    await Future.delayed(Duration(seconds: 3));

    // Check if the widget is still mounted before accessing the context
    if (mounted) {
      final authState = BlocProvider.of<AuthBloc>(context).state;
      if (authState is AuthFailureState) {
        context.go('/Intro');
      } else if (authState is AuthSuccessState) {
        context.go('/home');
      } else {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {



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
      }
  }

