// TODO Implement this library.
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
mixin ColorsApp {
static Color PrimaryColor = Color.fromRGBO(0, 150, 215, 1);
  static const Color SecondaryColor = Color.fromRGBO(248, 189, 0, 1);
  static const Color backgroundColored = Color.fromRGBO(255, 252, 255, 1);
  static const Color dotscolor = Color.fromRGBO(210, 210, 210, 1);
  static const Color ThirdColor = Color.fromRGBO(125, 125, 125, 1);
  static const Color textColorBlack = Color.fromRGBO(0, 0, 0, 1);
  static const Color BackWidgetColor = Color.fromRGBO(243, 243, 243, 1);
  static const Color textColor = Color.fromRGBO(194, 194, 194, 1);
  static const Color textColorWhite = Color.fromRGBO(255, 255, 255, 1);
}
class AppTheme with ColorsApp{}
const PrimaryColor = Color.fromRGBO(0, 150, 215, 1);
const SecondaryColor = Color.fromRGBO(248, 189, 0, 1);
const backgroundColored = Color.fromRGBO(255, 252, 255, 1);
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
  borderRadius: BorderRadius.circular(10.0),
  borderSide: BorderSide(color: color,width: 3 ),
);
final   taskdex=BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16.0),
  border: Border.all(
    color: textColor,
    width: 2,
  ),


);


EdgeInsetsGeometry paddingSemetricHorizontal ({double h=8})=> EdgeInsets.symmetric(horizontal:h );
EdgeInsetsGeometry paddingSemetricVertical ({double v=8})=> EdgeInsets.symmetric(vertical: v);
EdgeInsetsGeometry paddingSemetricAll ({double a=8})=> EdgeInsets.all(a);
EdgeInsetsGeometry paddingSemetricVerticalHorizontal ({double h=8,double v=8})=> EdgeInsets.symmetric(vertical: v,horizontal: h);







InputDecoration decorationTextField(String? errorText)=> InputDecoration(
    enabledBorder: border(textColorBlack) ,
    focusedBorder: border(PrimaryColor),
    errorBorder: border(Colors.red),
    focusedErrorBorder: border(Colors.red),
    errorStyle: ErrorStyle(18, Colors.red),
    errorText:errorText

);


final memberdeco= BoxDecoration(

    borderRadius: BorderRadius.circular(16.0),
    border: Border.all(
      color: ThirdColor,
      width: 3,
    ));
final ActivityDecoration=  BoxDecoration(

borderRadius:  const BorderRadius.only(
bottomLeft: Radius.circular(43),
bottomRight: Radius.circular(20),
topLeft: Radius.circular(15),
topRight: Radius.circular(15),
),
border: Border.all(color: BackWidgetColor, width: 1.0),
color: textColorWhite,

);



ButtonStyle bottondec(bool value)=>ElevatedButton.styleFrom(

  backgroundColor:  value?PrimaryColor:BackWidgetColor,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
);


ButtonStyle styleFrom(bool isActive) {
  return ElevatedButton.styleFrom(

    shadowColor: SecondaryColor.withOpacity(.3),
    splashFactory: InkRipple.splashFactory,
    surfaceTintColor: isActive?PrimaryColor:BackWidgetColor,
    side: const BorderSide(color: BackWidgetColor, width: 2),
    fixedSize: const Size(120, 40),
    elevation: 0,
    backgroundColor: isActive?PrimaryColor:textColorWhite,

    shape: RoundedRectangleBorder(

      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}


final taskDecoration=BoxDecoration(
    color: textColorWhite,
    borderRadius: BorderRadius.circular(15),
    border: Border.all(color: textColorBlack, width: 2),
    boxShadow: [
      BoxShadow(
        color: textColorBlack.withOpacity(.1),
        spreadRadius: 1,
        blurRadius: 2,
        offset: const Offset(0, 1), // changes position of shadow
      ),
    ]);





final shadowDecoration=BoxDecoration(
    color: textColorWhite,
    borderRadius: BorderRadius.circular(5),
    boxShadow:[
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 17,
        offset: const Offset(0, 5), // changes position of shadow
      ),
    ]
);
const ActivityRaduis=BorderRadius.only(

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
scaffoldBackgroundColor:backgroundColored ,
canvasColor: backgroundColored,
  textTheme: const TextTheme(

  ),
);

InputDecoration inputDecoration (mediaQuery,bool isempty,BuildContext context )=> InputDecoration(
  errorText:isempty ?"Empty Field":null,
  prefixIcon: const Icon(
    Icons.search,
    color: textColor,
  ),
  hintText: "Search by name or email".tr(context),
  hintStyle: PoppinsRegular(
    mediaQuery.devicePixelRatio * 5,
    textColor,

  ),

  focusedBorder: border(PrimaryColor),
  enabledBorder: border(ThirdColor),
  errorBorder: border(Colors.red),
  focusedErrorBorder: border(Colors.red),
  errorStyle: ErrorStyle(18, Colors.red),

);