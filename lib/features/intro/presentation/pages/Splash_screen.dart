

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/services/verification.dart';

import 'package:jci_app/core/widgets/loading_widget.dart';

import '../../../../core/strings/Images.string.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../auth/presentation/pages/pinPage.dart';

@RoutePage(

)
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




  check(context,mounted);

  }

  @override
  Widget build(BuildContext context) {



        return Container(
            decoration: const BoxDecoration(color: backgroundColored),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Expanded(child: Center(
                      child: Image.asset(images.jci,
                          width: 250, height: 250, fit: BoxFit.contain))),

                  const LoadingWidget()
                ],
              ),
            ));
      }
  }

