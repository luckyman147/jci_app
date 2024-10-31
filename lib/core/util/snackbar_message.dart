import 'package:flutter/material.dart';
import 'package:jci_app/core/app_theme.dart';

class SnackBarMessage {
 static  void showSuccessSnackBar(
      {required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0)
        //make it floating
     ,   behavior: SnackBarBehavior.floating,

        animation: CurvedAnimation(
      parent: AnimationController(
      vsync: Scaffold.of(context),
      duration: Duration(milliseconds: 300),
    ),
   curve: Curves.easeIn,
   ),


        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           Row(
             children: [
               const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                Padding(
                  padding: paddingSemetricHorizontal(h: 8),
                  child: Text(
                    message,
                    style: PoppinsSemiBold(17, ColorsApp.textColorBlack, TextDecoration.none),
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
      ),
    );
  }

 static  void showErrorSnackBar(
      {required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0)
        //make it floating
        ,   behavior: SnackBarBehavior.floating,

        animation: CurvedAnimation(
          parent: AnimationController(
            vsync: Scaffold.of(context),
            duration: Duration(milliseconds: 300),
          ),
          curve: Curves.easeIn,
        ),


        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.error,
                  color: ColorsApp.SecondaryColor,
                ),
                Padding(
                  padding: paddingSemetricHorizontal(h: 8),
                  child: Text(
                    message,
                    style: PoppinsSemiBold(17, ColorsApp.textColorBlack, TextDecoration.none),
                  ),
                ),
              ],
            ),
            // icon closed
            IconButton(onPressed: (){
              ScaffoldMessenger.of(context).hideCurrentSnackBar();


            }, icon: const Icon(Icons.close,color: ColorsApp.textColorBlack,)),
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
      ),
    );
  }
}
