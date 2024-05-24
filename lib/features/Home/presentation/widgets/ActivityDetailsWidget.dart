

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';

import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/widgets/ActivityImplWidgets.dart';
import 'package:jci_app/features/Home/presentation/widgets/Functions.dart';
import 'package:jci_app/features/Home/presentation/widgets/NotesWidget.dart';

import '../../../../core/app_theme.dart';
import '../../domain/entities/Activity.dart';
import '../bloc/Activity/BLOC/notesBloc/notes_bloc.dart';
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


                ActivityDetailsComponent.Description(mediaQuery, activitys),  buildNotes(mediaQuery, context),
],
            ),
          )
        ],
      ),
    );
  }

  Padding buildNotes(MediaQueryData mediaQuery, BuildContext context) {
    return Padding(

padding: paddingSemetricVerticalHorizontal(h: 20, v: 10),
child: SizedBox(
  width: mediaQuery.size.width,
  height: 70,
  child: InkWell(
    onTap: () {
      context.read<NotesBloc>().add(Notesfetched(activityId:activitys.id , isUpdated: true));

      ActivityAction.showNotes(context, mediaQuery,activitys);
    },


    child: DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(7),
      padding: EdgeInsets.all(6),
      color: textColorBlack,
        dashPattern: [12,16,13,16],
        child: Center(
          child: Text(" ${"View".tr(context)} Notes",style: PoppinsSemiBold(mediaQuery.devicePixelRatio*5, textColorBlack, TextDecoration.none),

                ),
        )

                    //Align(
                    //alignment: Alignment.topLeft,

                    //child: Text("Maps",style: PoppinsSemiBold(mediaQuery.devicePixelRatio*5, textColorBlack, TextDecoration.none), ))
    ),
  ),
),
);
  }


}
