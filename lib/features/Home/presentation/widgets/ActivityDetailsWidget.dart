

import 'package:flutter/material.dart';

import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/widgets/ActivityImplWidgets.dart';

import '../../domain/entities/Activity.dart';
import 'ActivityDetailsComponents.dart';


class ActivityDetail extends StatelessWidget {
  final Activity activitys;

  final activity act;
  final int index;

  const ActivityDetail(
      {Key? key, required this.activitys, required this.act, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Stack(

        children: [
          Stack(children: [

          ActivityDetailsComponent.ImageCard(mediaQuery, activitys),
            ActivityDetailsComponent.Back(mediaQuery, context),
            ActivityDetailsComponent.header(mediaQuery, context),
AddDots(activitys, mediaQuery)
          ]),
          Padding(
            padding: EdgeInsets.symmetric(vertical: mediaQuery.size.height / 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ActivityDetailsComponent.rowName(
                    mediaQuery, context, activitys, act, index),

                ActivityDetailsComponent.infoCircle(mediaQuery, activitys,context),
                ActivityDetailsComponent.Description(mediaQuery, activitys),


                //Align(
                //alignment: Alignment.topLeft,

                //child: Text("Maps",style: PoppinsSemiBold(mediaQuery.devicePixelRatio*5, textColorBlack, TextDecoration.none), ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
