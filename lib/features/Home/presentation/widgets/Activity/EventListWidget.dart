import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'package:intl/intl.dart';
import 'package:jci_app/core/app_theme.dart';

import 'package:jci_app/features/Home/domain/entities/Activitys/Activity.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';

import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/Participants/particpants_bloc.dart';

import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/widgets/Functions/Functions.dart';import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';
import 'package:jci_app/features/changelanguages/presentation/bloc/locale_cubit.dart';

import '../../../../../core/route/app_router.dart';
import '../../../domain/enums/ActivityEnum.dart';
import '../buttons/ParticpatedButton.dart';
import '../buttons/PinnedButton.dart';
import '../components/stuff/Compoenents.dart';
import '../components/stuff/NetworkCachedImageWidget.dart';
import '../shimmer/ShimmerButton.dart';

class ActivityWidget extends StatefulWidget {
  final List<Activity> Activities;
  final activity act;

  const ActivityWidget({
    Key? key,
    required this.Activities,
    required this.act,
  }) : super(key: key);

  @override
  State<ActivityWidget> createState() => _ActivityWidgetState();
}

class _ActivityWidgetState extends State<ActivityWidget> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return BlocBuilder<ActivityCubit, ActivityState>(
      builder: (context, state) {
        return ListView.separated(
            itemBuilder: (ctx, index) {
              bool isBefore = ActivityAction.isActivityBeforeToday(
                  widget.Activities[index].activityBasics.activityBeginDate,
                  widget.Activities[index].activityBasics.activityEndDate);
              bool isBetween = ActivityAction.isBetween(
                  widget.Activities[index].activityBasics.activityBeginDate,
                  widget.Activities[index].activityBasics.activityEndDate);
              return InkWell(
                onTap: () {
                  context.pushRoute(ActivityDetailsRoute(
                    id: widget.Activities[index].activityBasics.id,
                    activityType: state.selectedActivity.name,
                    index: index,
                  ));
                },
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    margin: paddingSemetricHorizontal(),
                    height: 250,
                    width: mediaQuery.size.width * 1.1,
                    decoration: BoxDecoration(
                      border: Border.all(color: textColor),
                    ),
                    child: Padding(
                      padding: paddingSemetricHorizontal(),
                      child: SizedBox(
                        width: mediaQuery.size.width / 2,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              widget.Activities[index].activityBasics.coverImages.isNotEmpty
                                  ? InkWell(
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        context.pushRoute(ActivityDetailsRoute(
                                          id: widget.Activities[index].activityBasics.id,
                                          activityType: state.selectedActivity.name,
                                          index: index,
                                        ));
                                      },
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: CachedNetworkImageWidget(
                                            item: widget.Activities[index]
                                                .activityBasics.coverImages[0],
                                            height: mediaQuery.size.height / 6,
                                            width: 130.w,
                                          )),
                                    )
                                  : InkWell(
                                      highlightColor: Colors.transparent,
                                      onLongPress: () {
                                        context.pushRoute(ActivityDetailsRoute(
                                          id: widget.Activities[index].activityBasics.id,
                                          activityType: state.selectedActivity.name,
                                          index: index,
                                        ));
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: SizedBox(
                                          height: mediaQuery.size.height / 5.8,
                                          width: 130.w,
                                          child: Image.asset(
                                            'assets/images/jci.png',
                                            fit: BoxFit.contain,
                                            scale: 0.1,
                                          ),
                                        ),
                                      ),
                                    ),
                              BlocBuilder<localeCubit, LocaleState>(
                                builder: (context, state) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Text("${"Start At".tr(context)} ${DateFormat('h:mm').format(widget.Activities[index].ActivityBeginDate)}",style: PoppinsRegular(mediaQuery.devicePixelRatio*5, isBefore?Colors.red:isBetween?Colors.green:textColorBlack),),
                                        SizedBox(
                                            width: mediaQuery.size.width / 3,
                                            child: Text(
                                              widget.Activities[index].activityBasics.name
                                                  .toUpperCase(),
                                              overflow: TextOverflow.ellipsis,
                                              style: PoppinsSemiBold(
                                                  widget.Activities[index].activityBasics.name
                                                              .length <
                                                          10
                                                      ? mediaQuery
                                                              .devicePixelRatio *
                                                          7
                                                      : mediaQuery
                                                              .devicePixelRatio *
                                                          6,
                                                  textColorBlack,
                                                  TextDecoration.none),
                                            )),
                                          SizedBox(
                                          width: mediaQuery.size.width / 2.5,
                                          child: Text(
                                            "${DateFormat('EEEE MMM d  h:mm', state.locale == const Locale('en') ? 'en_US' : 'fr_FR').format(widget.Activities[index].activityBasics.activityBeginDate)} ",
                                            style: PoppinsSemiBold(
                                                mediaQuery.devicePixelRatio * 6,
                                                isBefore
                                                    ? Colors.red
                                                    : isBetween
                                                        ? Colors.green
                                                        : textColorBlack,
                                                TextDecoration.none),
                                          ),
                                        ),

                                        SizedBox(
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on_outlined,
                                                color: textColorBlack,
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width:
                                                    mediaQuery.size.width / 2,
                                                child: Text(
                                                  widget.Activities[index]
                                                      .activityBasics.activityAdress,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: PoppinsLight(
                                                    widget
                                                                .Activities[
                                                                    index]
                                                                .activityBasics.activityAdress
                                                                .length <
                                                            20
                                                        ? mediaQuery
                                                                .devicePixelRatio *
                                                            4.5
                                                        : mediaQuery
                                                                .devicePixelRatio *
                                                            4,
                                                    textColorBlack,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        BlocBuilder<ParticpantsBloc,
                                            ParticpantsState>(
                                          builder: (context, state) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  button(
                                                      Activities:
                                                          widget.Activities,
                                                      mediaQuery: mediaQuery,
                                                      index: index,
                                                      act: widget.act,
                                                      context: context),
                                                  Pinnedbutton(
                                                    onTap: (Activity) {
                                                      //context.read<AcivityFBloc>().add(AddPinnedEvent(act: Activity));
                                                    },
                                                    isPinned: false,
                                                    activity: widget
                                                        .Activities[index],
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                },
                              )
                            ]),
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 20,
              );
            },
            itemCount: widget.Activities.length);
      },
    );
  }

  Widget button(
      {required MediaQueryData mediaQuery,
      required List<Activity> Activities,
      required int index,
      required activity act,
      required BuildContext context}) {
    return BlocBuilder<AcivityFBloc, AcivityFState>(
      builder: (context, state) {
        Logger().w(state.activitiesSearch[index].participation.participants);
        return
              // Show the ParticipateButton with data when data is available
             ParticipateButton(
                key:
                    UniqueKey(), // Ensure widget is rebuilt when its properties change
                acti: Activities[index],
                index: index,
                isPartFromState: ActivityAction.checkifMemberExist(
                    state.activitiesSearch[index].participation.participants,
                    context),
                act: act,
                textSize: mediaQuery.devicePixelRatio * 4.5,
                containerWidth: mediaQuery.size.width / 3,
              );

      },
    );
  }
}
class ActivityOfMonthListWidget extends StatelessWidget {
  final List<Activity> activities;
  final activity act;

  const ActivityOfMonthListWidget({
    Key? key,
    required this.activities,
    required this.act,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return BlocBuilder<ActivityCubit, ActivityState>(
      builder: (context, state) {
        return ListView.separated(
          scrollDirection: Axis.vertical, // Make it vertical
          itemCount: activities.length,
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemBuilder: (context, index) {
            final currentActivity = activities[index];

            return GestureDetector(
              onTap: () {
                context.pushRoute(ActivityDetailsRoute(
                  id: currentActivity.activityBasics.id,
                  activityType: state.selectedActivity.name,
                  index: index,
                ));
              },
              child: Container(
padding: paddingSemetricVerticalHorizontal(),

                decoration: ActivityDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 10,
                  children: [
                    images(
                      mediaQuery,
                      activities,
                      index,
                      mediaQuery.size.height / 5.2,
                      mediaQuery.size.width,
                    ),
                    const SizedBox(height: 8),

                    details(mediaQuery, activities, index, context),
                    const SizedBox(height: 12),
                    ButtonComponent(
                      Activities: activities,
                      index: index,
                      top: 0, // Not used in Column layout
                      left: 0, // Not used in Column layout
                      mediaQuery: mediaQuery,
                      act: act,
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 20);
          },
        );
      },
    );
  }
}


ClipRRect images(mediaQuery, List<Activity> activity, int index, double height,
        double width) =>
    activity[index].activityBasics.coverImages.isNotEmpty
        ? ClipRRect(
            borderRadius: ActivityRaduis,
            child: Container(
                height: height,
                width: width,
                color: Colors.grey,
                child: CachedNetworkImageWidget(
                  item: activity[index].activityBasics.coverImages[0],
                  height: height,
                  width: height,
                )))
        : ClipRRect(
            borderRadius: ActivityRaduis,
            child: Container(
              height: height,
              width: width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/jci.png'),
                      fit: BoxFit.cover)),
            ),
          );

Widget details(MediaQueryData mediaQuery, List<Activity> activity,
        int index, BuildContext context) =>
 Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: BlocBuilder<localeCubit, LocaleState>(
          builder: (context, state) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Text(
                      "${DateFormat('dd MMMM yyyy',
                          state.locale == const Locale("en") ? 'en_US' : 'fr_FR').format(activity[index].activityBasics.activityBeginDate)} à"
                          " ${DateFormat('HH:mm').format(activity[index].activityBasics.activityBeginDate)}",
                      style: PoppinsRegular(
                          mediaQuery.devicePixelRatio * 5.5, textColorBlack),
                    ),
                  ),
                  SizedBox(
                      width: mediaQuery.size.width,
                      child: Text(
                        activity[index].activityBasics.name,
                        overflow: TextOverflow.ellipsis,
                        style: PoppinsSemiBold(mediaQuery.devicePixelRatio * 5,
                            textColorBlack, TextDecoration.none),
                      )),
                  SizedBox(
                      width: mediaQuery.size.width,
                      child: Text(
                        activity[index].activityBasics.activityAdress,
                        overflow: TextOverflow.ellipsis,
                        style: PoppinsLight(
                          activity[index].activityBasics.activityAdress.length < 20
                              ? mediaQuery.devicePixelRatio * 5
                              : mediaQuery.devicePixelRatio * 4,
                          textColorBlack,
                        ),
                      )),
                  SizedBox(
                      child: Text(
                    "${activity[index].participation.participants.length}  Participants",
                    style: PoppinsNorml(
                      mediaQuery.devicePixelRatio * 4,
                      textColorBlack,
                    ),
                  )),
                ],

            );
          },
        ),
      );


Positioned PosCard(mediaQuery, List<Activity> activity, int index) =>
    Positioned(
      top: mediaQuery.size.height / 20.6,
      left: 20,
      child: Container(
        decoration: shadowDecoration,
        height: 50,
        width: 50,
        child: Center(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  activity[index].activityBasics
                      .activityBeginDate
                      .day
                      .toString()
                      .padLeft(2, '0'),
                  style: PoppinsSemiBold(18, PrimaryColor, TextDecoration.none),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  DateFormat('MMM').format(activity[index].
                  activityBasics.activityBeginDate),
                  style: PoppinsNorml(15, textColorBlack),
                ),
              ),
            ],
          ),
        ),
      ),
    );
