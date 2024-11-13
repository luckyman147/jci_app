import 'package:flutter/material.dart';
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
      duration: Duration(seconds: 10),
    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0)
    //make it floating
       ,   behavior: SnackBarBehavior.floating,

    animation: CurvedAnimation(
  parent: AnimationController(
  vsync: Scaffold.of(context),
  duration: Duration(seconds: 1),
      ),
     curve: Curves.easeIn,
     ),


    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       Row(
         mainAxisSize: MainAxisSize.min,
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [

            Icon(
              icon,
              color: color,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              child: Text(
                message,
                overflow: TextOverflow.ellipsis,
                style: PoppinsSemiBold(14, ColorsApp.textColorBlack, TextDecoration.none),
              ),
            ),
         ],
       ),
        // icon closed
  IconButton(onPressed: (){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();


  }, icon: Icon(Icons.close,color: ColorsApp.textColorBlack,)),
      ],
    ),
    backgroundColor: ColorsApp.textColorWhite,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(
        color: ColorsApp.textColor,
        width: 2,
      ),
    ),
  );
  }

