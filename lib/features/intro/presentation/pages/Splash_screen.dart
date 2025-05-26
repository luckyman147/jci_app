import 'package:flutter/material.dart';

import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/services/verification.dart';

import 'package:jci_app/core/widgets/loading_widget.dart';

import '../../../../core/config/services/MemberStore.dart';
import '../../../../core/config/services/store.dart';
import '../../../../core/strings/Images.string.dart';
import '/injection_container.dart' as di;
class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final st = di.sl<Store>();
  final member = di.sl<MemberStore>();
 late  Verification verification;
  @override
  void initState() {
    super.initState();
    verification = di.sl<Verification>();
    _navigateAfterDelay();
  }

  void _navigateAfterDelay() async {
    verification.check(context,mounted);
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(AssetImage(images.jci), context); // Preload the image
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: backgroundColored),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Center(
                      child: Image.asset(
                images.jci,
                width: 250,
                height: 250,
                fit: BoxFit.contain,
                gaplessPlayback: true,
              ))),
              const LoadingWidget()
            ],
          ),
        ));
  }
}
