import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/app.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';

class SnackBarMessage {
 static  void showSuccessSnackBar(
      {required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      buildSnackBar(context, message, Icons.check_circle ,Colors.green),
    );
  }

 static  void showErrorSnackBar(
      {required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      buildSnackBar(context, message, Icons.error, Colors.red) ,
    );
  }
}

  SnackBar buildSnackBar(BuildContext context  , String message
  ,IconData icon,
   Color color) {
    return SnackBar(

      duration: const Duration(seconds: 3),
    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0)
    //make it floating
       ,   behavior: SnackBarBehavior.floating,

    animation: CurvedAnimation(
  parent: AnimationController(
  vsync: Scaffold.of(context),
  duration: const Duration(seconds: 1),
      ),
     curve: Curves.easeIn,
     ),


    content: SingleChildScrollView(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
      
           Padding(
             padding: paddingSemetricHorizontal(),
             child: Icon(
               icon,
               color: ColorsApp.textColorWhite,
             ),
           ),
           SingleChildScrollView(
             scrollDirection: Axis.horizontal,
             child: AutoSizeText(
               message,

               style: PoppinsNorml(14.sp, textColorWhite,),
             ),
           ),
        ],
      ),
    ),
    backgroundColor: color,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),

    ),
  );
  }

