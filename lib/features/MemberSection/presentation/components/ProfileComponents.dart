


import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jci_app/features/MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';


import '../../../../core/app_theme.dart';


import '../constants/decoration.dart';


import 'AboutMemberComponent.dart';



class ProfileComponents {

  static bool isInitial(StatesBool value) => value == StatesBool.Initial;

  static bool isDes(StatesBool value) => value == StatesBool.Description;

  static bool iTeams(StatesBool value) => value == StatesBool.Teams;

  static bool iActivities(StatesBool value) => value == StatesBool.Activities;

  static bool iMembers(StatesBool value) => value == StatesBool.Members;

  static bool isPoints(StatesBool value) => value == StatesBool.Points;

  static bool isObjectif(StatesBool value) => value == StatesBool.Objectifs;

  static bool isJCI(StatesBool value) => value == StatesBool.JCI;


  /// member s info component
  static Widget BuildInfoRow(IconData icon, String text) {
    return Padding(
      padding: paddingSemetricVerticalHorizontal(),
      child: Center(
        child: Container(
          decoration: boxDecoration,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(icon, color: textColorBlack,),
                Padding(
                  padding: paddingSemetricHorizontal(),
                  child: Text(
                    text, style: PoppinsRegular(17, textColorBlack,),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}

class StaticsContainer extends StatelessWidget {
  final String number; // Number to display
  final String text;   // Text to display
final Color color;
final Function() onTap;
  // Color of the container
  const StaticsContainer({
    Key? key,
    required this.number,
    required this.text, required this.color, required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingSemetricVertical(),
      child: InkWell(
        onTap: onTap,

        child: Container(
height: 100.h,
          width: MediaQuery.of(context).size.width/3.2,
          decoration: AboutMemberComponent.profilbox().copyWith(
            color: color,border: Border.all(color: ColorsApp.textColorBlack,width: 2),

          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Minimize the size of the Column
                children: [
                  AutoSizeText(
                    text, // Display the text
                    style: PoppinsSemiBold(15.sp, ColorsApp.textColorWhite,TextDecoration.none),
                  ),
                  SizedBox(height: 4), // Space between number and text
              AutoSizeText(

                    number, // Display the number
                    style: PoppinsSemiBold(20.sp, ColorsApp.textColorWhite, TextDecoration.none),
                  ),
                ],
              ),
            ),
          ),
        ).animate(
          effects: [const ScaleEffect(
            duration: Duration(milliseconds: 478)
          )]

        ),
      ),
    );
  }
}
