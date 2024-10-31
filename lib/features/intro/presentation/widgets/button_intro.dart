import 'package:flutter/material.dart';
import 'package:jci_app/core/app_theme.dart';

class button_intro_widget_filled extends StatelessWidget {
const button_intro_widget_filled({Key? key, required this.text, required this.onPressed}) : super(key: key);
final Function onPressed;
final String text;
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mediaQuery.size.width *.1,vertical: mediaQuery.size.height * 0.02),
      child: InkWell(
      onTap: () {
          onPressed();
        },
        child: Container(
          height: mediaQuery.size.height * 0.08,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: PrimaryColor,
          ),




             child: Center(child: Text(text,style: PoppinsSemiBold(24, textColorWhite,TextDecoration.none),)),

        ),
      ),
    );


  }
}
class button_intro_widget extends StatelessWidget {
const button_intro_widget({Key? key, required this.text, required this.onPressed}) : super(key: key);
final Function onPressed;
final String text;
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return Padding(
      padding:  EdgeInsets.only(top: mediaQuery.size.width * 0.2),
      child: InkWell(
        splashColor: Colors.transparent,
highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: () {
          onPressed();
        },
        child: Center(child: Text(text,style: PoppinsSemiBold(22, ColorsApp.PrimaryColor,TextDecoration.none),)),
      ),
    );


  }
}
