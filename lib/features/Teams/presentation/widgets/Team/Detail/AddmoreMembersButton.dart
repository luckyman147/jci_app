import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:jci_app/core/app_theme.dart';

Widget addMoreMembersButton(BuildContext context) {
  return
    SizedBox(
      width: MediaQuery.of(context).size.width,
      child:
    Padding(padding: paddingSemetricVerticalHorizontal() ,child: DottedBorder(
    color: ColorsApp.textColor, // Border color
    strokeWidth: 1.5,
    borderType: BorderType.RRect,
    radius: Radius.circular(12),
    dashPattern: [16, 3],
    child: InkWell(
      onTap: () {
        // Handle tap
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(

         mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.share, color: ColorsApp.textColor),
            SizedBox(width: 8),
            Text(
              "Add more members",
              style: PoppinsRegular(
              16,
                ColorsApp.textColor,

              ),
            ),
          ],
        ),
      ),
    ),
  )));
}
