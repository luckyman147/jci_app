import 'package:flutter/material.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import '../../../../../../../core/app_theme.dart';

class ChooseHeader extends StatelessWidget {
  final String text;


  const ChooseHeader({
    Key? key,
    required this.text,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Text(
      "${"Choose".tr(context)} $text",
      style: PoppinsSemiBold(
        mediaQuery.devicePixelRatio * 7,
        ColorsApp.textColorBlack,
        TextDecoration.none,
      ),
    );
  }
}
