import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/widgets/loading_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      context.go('/Intro');
      // Navigator.pushReplacementNamed(context, '/login');
    });
  } @override
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

              const LoadingWidget()
            ],
          ),
        ));
  }
}
