import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/Home/Activity_Global.dart';

import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/widgets/Activity/ActivityImplWidgets.dart';
import 'package:jci_app/features/Home/presentation/widgets/Functions/Functions.dart';

import '../../../../../core/app_theme.dart';
import '../../../domain/entities/Activity.dart';

import '../../bloc/ChangeString/change_string_bloc.dart';
import '../Implementations/ActivtysImplementations.dart';
import '../activityDetailsWidget/Containerdivider.dart';
import '../activityDetailsWidget/ImageListCard.dart';
import '../activityDetailsWidget/SectionViews.dart';
import 'ActivityDetailsComponents.dart';

class ActivityDetail extends StatefulWidget {
  final Activity activitys;

  final activity act;
  final int index;

  const ActivityDetail(
      {Key? key,
      required this.activitys,
      required this.act,
      required this.index})
      : super(key: key);

  @override
  State<ActivityDetail> createState() => _ActivityDetailState();
}

class _ActivityDetailState extends State<ActivityDetail> {
  @override
  void initState() {
    context.read<ParticpantsBloc>().add(LoadParticipantIdEvent());
    // TODO: implement initState
    super.initState();
    if (widget.act != activity.Meetings) {
      context
          .read<ChangeStringBloc>()
          .add(initImageEvent(image: widget.activitys.CoverImages));
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Stack(
        children: [
          BuildFirstPart(mediaQuery),
          Padding(
            padding: widget.act != activity.Meetings
                ? EdgeInsets.symmetric(vertical: mediaQuery.size.height / 2.5)
                : EdgeInsets.symmetric(vertical: 70.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ActivityDetailsComponent.rowName(mediaQuery, context,
                    widget.activitys, widget.act, widget.index),
                NoImageCard(ColorsApp.BackWidgetColor, 20),

                SectionViewer(
                    act: widget.act,
                    id: context.read<ParticpantsBloc>().state.userId),
                //ActivityDetailsComponent.infoCircle(mediaQuery, widget.activitys,context),

                // ActivityDetailsComponent.Description(mediaQuery, widget.activitys),  buildNotes(mediaQuery, context),
              ],
            ),
          )
        ],
      ),
    );
  }

  BlocBuilder<ChangeStringBloc, ChangeStringState> BuildFirstPart(
      MediaQueryData mediaQuery) {
    return BlocBuilder<ChangeStringBloc, ChangeStringState>(
      builder: (context, state) {
        return Stack(children: [
          widget.act != activity.Meetings
              ? ActivityDetailsComponent.ImageCard(
                  mediaQuery, state.image, context)
              : NoImageCard(ColorsApp.textColorWhite, 100),
          ActivityDetailsComponent.Back(mediaQuery, context),
          ActivityDetailsComponent.header(
              mediaQuery, context, widget.act == activity.Meetings),
          AddDots(widget.activitys, mediaQuery),
          widget.activitys.CoverImages.isNotEmpty
              ? ImageListCard(
                  images: widget.activitys.CoverImages
                      .map((e) => e.toString())
                      .toList(),
                )
              : const SizedBox(),
          ShadowWidget(mediaQuery)
        ]);
      },
    );
  }

  Positioned ShadowWidget(MediaQueryData mediaQuery) {
    return Positioned(
      bottom: 0,
      child: Align(
          alignment: Alignment.center,
          child: Container(
            height: 20.h,
            width: mediaQuery.size.width,
            decoration: const BoxDecoration(
              // Add transparency to make layers visible
              boxShadow: [
                BoxShadow(
                  color: ColorsApp
                      .textColorWhite, // Shadow color with some transparency
                  spreadRadius: 5, // Spread radius
                  blurRadius: 20, // Blur radius for a softer shadow
                  // Offset: 0 for horizontal, positive Y for bottom shadow
                ),
              ],
            ),
          )),
    );
  }

/*  Padding buildNotes(MediaQueryData mediaQuery, BuildContext context) {
    return Padding(

padding: paddingSemetricVerticalHorizontal(h: 20, v: 10),
child: SizedBox(
  width: mediaQuery.size.width,
  height: 70,
  child: InkWell(
    onTap: () {
      context.read<NotesBloc>().add(Notesfetched(activityId:widget.activitys.id , isUpdated: true));

      ActivityAction.showNotes(context, mediaQuery,widget.activitys);
    },


    child: Container(
     decoration: BoxDecoration(
       color: textColorWhite,
       border: Border.all(color: textColorBlack,),
       borderRadius: BorderRadius.circular(10),
     ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: paddingSemetricHorizontal(),
                child: const Icon(Icons.mode_comment_outlined, color: textColorBlack,),
              ),
              Text(" ${"View".tr(context)} Notes",style: PoppinsSemiBold(mediaQuery.devicePixelRatio*6, textColorBlack, TextDecoration.none),

                    ),
            ],
          ),
        )

                    //Align(
                    //alignment: Alignment.topLeft,

                    //child: Text("Maps",style: PoppinsSemiBold(mediaQuery.devicePixelRatio*5, textColorBlack, TextDecoration.none), ))
    ),
  ),
),
);
  }*/
}
