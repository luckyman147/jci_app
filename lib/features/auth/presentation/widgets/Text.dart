
import 'package:flutter/material.dart';
import 'package:jci_app/core/app_theme.dart';



class  TextWidget extends StatelessWidget {
  String text;
  double size;
  TextWidget({super.key, required this.text,required this.size});


  @override
  Widget build(BuildContext context) {
    return  Text(text,style:PoppinsSemiBold(size, textColorBlack,TextDecoration.none) ,);
  }
}
class  Label extends StatelessWidget {
  String text;
  double size;
  Label({super.key, required this.text,required this.size});


  @override
  Widget build(BuildContext context) {
    return  Text(text,style:PoppinsLight(size, ColorsApp.textColorBlack) ,);
  }
}

Widget line(double width)=> SizedBox(
  width: width, // Set a fixed width for the Divider
  child: const Divider(color:ColorsApp.ThirdColor ,thickness: 1,height: 20,),
);
class  LinkedText extends StatelessWidget {
  String text;
  double size;
  LinkedText({super.key, required this.text,required this.size});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(text,style:PoppinsSemiBold(size, ColorsApp.PrimaryColor,TextDecoration.underline) ,);
  }
}
Widget header(String text,MediaQueryData mediaquery){
  return Align(
      alignment:    Alignment.topLeft,
      child: Label(text: text, size: mediaquery.size.width/22.5));
}
Widget divider(MediaQueryData mediaquery) {
  return       Padding(
    padding:  paddingSemetricVertical(v: mediaquery.size.height *.01),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        line(mediaquery.size.width/3),


        Padding(
          padding: paddingSemetricHorizontal(),
          child: Text("Or",style: PoppinsNorml(mediaquery.size.width/24,ColorsApp. ThirdColor),),
        ),
        line(mediaquery.size.width/3)
        //   Divider(),

      ],
    ),
  );
}