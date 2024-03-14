// TODO Implement this library.
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

const PrimaryColor = Color.fromRGBO(0, 150, 215, 1);
const SecondaryColor = Color.fromRGBO(248, 189, 0, 1);
const backgroundColored = Color.fromRGBO(244, 252, 255, 1);
const dotscolor= Color.fromRGBO(210, 210, 210, 1);
const ThirdColor= Color.fromRGBO(125, 125, 125, 1);
const textColorBlack = Color.fromRGBO(0, 0, 0, 1);
const BackWidgetColor = Color.fromRGBO(243, 243, 243, 1);
const textColor = Color.fromRGBO(194 , 194, 194, 1);
const textColorWhite = Color.fromRGBO(255, 255, 255, 1);
TextStyle PoppinsLight(double size,Color color)=> GoogleFonts.poppins(fontWeight: FontWeight.w400,fontSize: size,color: color);
TextStyle PoppinsNorml(double size,Color color) => GoogleFonts.poppins(fontWeight: FontWeight.normal,fontSize: size,color: color);
TextStyle PoppinsRegular(double size,Color color) => GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: size,color: color);
TextStyle PoppinsSemiBold(double size,Color color,TextDecoration decoration) => GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: size,color: color,decoration: decoration,decorationColor: PrimaryColor);
TextStyle PoppinBold(double size,Color color,TextDecoration decoration) => GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: size,color: color,decoration: decoration,decorationColor: PrimaryColor);
TextStyle ErrorStyle(double size,Color color) => GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: size,color: color);
OutlineInputBorder border(Color color)=> OutlineInputBorder(
  borderRadius: BorderRadius.circular(16.0),
  borderSide: BorderSide(color: color,width: 3 ),
);

final memberdeco= BoxDecoration(

    borderRadius: BorderRadius.circular(16.0),
    border: Border.all(
      color: ThirdColor,
      width: 3,
    ));
final ActivityDecoration=  BoxDecoration(

borderRadius:  BorderRadius.only(
bottomLeft: Radius.circular(43),
bottomRight: Radius.circular(43),
topLeft: Radius.circular(15),
topRight: Radius.circular(15),
),
border: Border.all(color: BackWidgetColor, width: 1.0),
color: textColorWhite,

);



ButtonStyle bottondec(bool value)=>ElevatedButton.styleFrom(

  primary: value?PrimaryColor:BackWidgetColor,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
);
final shadowDecoration=BoxDecoration(
    color: textColorWhite,
    borderRadius: BorderRadius.circular(5),
    boxShadow:[
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 17,
        offset: Offset(0, 5), // changes position of shadow
      ),
    ]
);
final ActivityRaduis=BorderRadius.only(

  topLeft: Radius.circular(15),
  topRight: Radius.circular(15),
);
final decoration=BoxDecoration(
  color: PrimaryColor,

  borderRadius: BorderRadius.circular(16.0),
  border: Border.all(color: textColorBlack, width: 2.0),
);

ThemeData themeData = ThemeData(
  primaryColor: PrimaryColor,
scaffoldBackgroundColor:textColorWhite ,


  textTheme: TextTheme(

  ),
);