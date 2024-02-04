
import 'package:flutter/material.dart';
import 'package:jci_app/core/app_theme.dart';


class  TextWidget extends StatelessWidget {
  String text;
  double size;
  TextWidget({required this.text,required this.size});


  @override
  Widget build(BuildContext context) {
    return  Text(text,style:PoppinsSemiBold(size, textColorBlack,TextDecoration.none) ,);
  }
}
class  Label extends StatelessWidget {
  String text;
  double size;
  Label({required this.text,required this.size});


  @override
  Widget build(BuildContext context) {
    return  Text(text,style:PoppinsLight(size, textColorBlack) ,);
  }
}
class  LinkedText extends StatelessWidget {
  String text;
  double size;
  LinkedText({required this.text,required this.size});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(text,style:PoppinsSemiBold(size, PrimaryColor,TextDecoration.underline) ,);
  }
}
