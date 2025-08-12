import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/core/app_theme.dart';

class TaskHeader extends StatelessWidget {
  final String title;
  final Color color;
  final bool isColumn;
  final int numTasks;

  const TaskHeader({

    super.key,
    this.numTasks = 0,

    required this.title,
    required this.color,
    this.isColumn = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isColumn) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style:PoppinsSemiBold(16.sp, color, TextDecoration.none),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Container(
            height: 3,
            width: 50,
            color: color,
          ),
        ],
      );
    } else {
      return
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          child:   Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
           Row(
             children: [
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                title,
                style:PoppinsSemiBold(16.sp, color, TextDecoration.none),

              ),

             ],
           )
              ,
              Text(
                "$numTasks Tasks",
                style:PoppinsLight(12.sp, ColorsApp.ThirdColor),

              ),


            ],
          ) ,
        );

    }
  }
}
