import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jci_app/core/app_theme.dart';

import '../../../../../Home/domain/entities/Activitys/ActivityBasics.dart';

class ActivityInfoTile extends StatelessWidget {
  final ActivityBasics activity;

  const ActivityInfoTile({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("dd MMM yyyy, HH:mm");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding:paddingSemetricHorizontal(h: 16),
          child: Text(
            "Event Infos",
            style: PoppinsRegular(18, ColorsApp.textColorBlack)
          ),
        ),
        Container(

          margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          decoration: BoxDecoration(


          ),
          child: ListTile(
            style: ListTileStyle.drawer,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            tileColor: ColorsApp.textColorWhite,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: ColorsApp.BackWidgetColor, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),

            leading: activity.coverImages.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:

              Image.network(
                activity.coverImages.first,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            )
                : const Icon(Icons.event, size: 30, color: ColorsApp.SecondaryColor),
            title: Text(
              activity.name,
              style: PoppinsSemiBold(16, ColorsApp.textColorBlack, TextDecoration.none),
            ),
            subtitle: Text(
              style: PoppinsLight(12, ColorsApp.ThirdColor),
              "${dateFormat.format(activity.activityBeginDate)} → ${dateFormat.format(activity.activityEndDate)}",
            ),
          ),
        ),
      ],
    );
  }
}
