import 'package:flutter/material.dart';
import 'package:jci_app/core/app_theme.dart';

class button_intro_widget extends StatelessWidget {
const button_intro_widget({Key? key, required this.text, required this.onPressed}) : super(key: key);
final Function onPressed;
final String text;
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return ElevatedButton(onPressed: () { onPressed(); },


  style: ElevatedButton.styleFrom(
    padding:  EdgeInsets.symmetric(horizontal: mediaQuery.size.width/6.5, vertical: 20),
    backgroundColor: PrimaryColor,
    side: const BorderSide(color: PrimaryColor,style: BorderStyle.none,strokeAlign: BorderSide.strokeAlignOutside,width: 0),

    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
  Radius.zero
      ),
    ),
  ), child: Center(child: Text(text,style: PoppinsSemiBold(24, textColorWhite,TextDecoration.none),)),
);


  }
}
