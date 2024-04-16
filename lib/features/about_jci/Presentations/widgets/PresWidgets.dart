import 'package:flutter/material.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';

import 'Fubnctions.dart';

class PresWidgets{

  static double  FirstDescriptionHeight(BuildContext context) => JCIFunctions.getHeight("description_jci_Inter".tr(context), 16, MediaQuery.of(context).size.width/1.7);
  static double  SecondDescriptionHeight(BuildContext context) => JCIFunctions.getHeight("description_jci_Tunisia".tr(context), 16, MediaQuery.of(context).size.width/1.7);
  static double  ThirdDescriptionHeight(BuildContext context) => JCIFunctions.getHeight("description_jci_HammamSousse".tr(context), 16, MediaQuery.of(context).size.width/1.7);
  static Padding HeaderText(String title,BuildContext context){
    return Padding(
      padding: paddingSemetricHorizontal(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
width: MediaQuery.of(context).size.width/1.1,
            child: Text(title,
                textAlign: TextAlign.justify,

                style:PoppinsSemiBold(16, textColorBlack, TextDecoration.none)),
          ),
          BorderGradients(),
        ],
      ),
    );
  }
  static Padding description(String text,String images,BuildContext context){
    return Padding(
      padding: paddingSemetricHorizontal(),
      child: Column(
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width/1.5,
              child: Text(text,

                  style:PoppinsRegular(17, textColorBlack, ))),

          SizedBox(height: 10,),


        ],
      ),
    );
  }

static   Container BorderGradients() {
    return Container(
      width: 200.0,
      height: 5.0,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 4.0,
            color: Colors.transparent, // Transparent color for the border
          ),
        ),
        gradient: LinearGradient(
          colors: [PrimaryColor, SecondaryColor], // Gradient colors
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  static SizedBox buildSlider(BuildContext context, List<double> heights, List<String> images) {
    List<Color> colors = [PrimaryColor, Colors.green,SecondaryColor];
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: heights.reduce((a, b) => a + b),
      child: ListView.builder(
        itemCount: heights.length * 2 , // Number of circles and dividers
        itemBuilder: (context, index) {
          if (index.isEven ) {
            // Circle
            int imageIndex = index ~/ 2;
            return Center(
              child: Container(
                width: 100.0,
                height: 100.0,
                child: CircleAvatar(
                  radius: 100.0,
                  backgroundImage: AssetImage(images[imageIndex]),
                ),
              ),
            );
          } else {
            // Divider
            int dividerIndex = (index - 1) ~/ 2;
            return Container(
              height: heights[dividerIndex]-20,
              child: VerticalDivider(
                color: colors[dividerIndex],
                thickness: 1.0,
              ),
            );
          }
        },
      ),
    );
  }


}