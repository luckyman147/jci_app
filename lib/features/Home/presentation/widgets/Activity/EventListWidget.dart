import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jci_app/core/app_theme.dart';

import 'package:jci_app/features/Home/domain/entities/Activity.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';

import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/Participants/particpants_bloc.dart';

import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/widgets/Functions/Functions.dart';
import 'package:jci_app/features/Home/presentation/widgets/components/NetworkCachedImageWidget.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';
import 'package:jci_app/features/changelanguages/presentation/bloc/locale_cubit.dart';

import '../../../domain/enums/ActivityEnum.dart';
import '../buttons/ParticpatedButton.dart';
import '../buttons/PinnedButton.dart';
import '../components/Compoenents.dart';
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
                  widget.Activities[index].ActivityBeginDate,
                  widget.Activities[index].ActivityEndDate);
              bool isBetween = ActivityAction.isBetween(
                  widget.Activities[index].ActivityBeginDate,
                  widget.Activities[index].ActivityEndDate);
              return InkWell(
                onTap: () {
                  context.go(
                      '/activity/${widget.Activities[index].id}/${state.selectedActivity.name}/$index');
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
                              widget.Activities[index].CoverImages.isNotEmpty
                                  ? InkWell(
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        context.go(
                                            '/activity/${widget.Activities[index].id}/${state.selectedActivity.name}/$index');
                                      },
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: CachedNetworkImageWidget(
                                            item: widget.Activities[index]
                                                .CoverImages[0],
                                            height: mediaQuery.size.height / 6,
                                            width: 130.w,
                                          )),
                                    )
                                  : InkWell(
                                      highlightColor: Colors.transparent,
                                      onLongPress: () {
                                        context.go(
                                            '/activity/${widget.Activities[index].id}/${state.selectedActivity.name}/$index');
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
                                              widget.Activities[index].name
                                                  .toUpperCase(),
                                              overflow: TextOverflow.ellipsis,
                                              style: PoppinsSemiBold(
                                                  widget.Activities[index].name
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
                                            "${DateFormat('EEEE MMM d  h:mm', state.locale == const Locale('en') ? 'en_US' : 'fr_FR').format(widget.Activities[index].ActivityBeginDate)} ",
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
                                                      .ActivityAdress,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: PoppinsLight(
                                                    widget
                                                                .Activities[
                                                                    index]
                                                                .ActivityAdress
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
        Logger().w(state.activitiesSearch[index].Participants);
        return
              // Show the ParticipateButton with data when data is available
             ParticipateButton(
                key:
                    UniqueKey(), // Ensure widget is rebuilt when its properties change
                acti: Activities[index],
                index: index,
                isPartFromState: ActivityAction.checkifMemberExist(
                    state.activitiesSearch[index].Participants,
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
  final List<Activity> Activities;

  final activity act;
  const ActivityOfMonthListWidget({
    Key? key,
    required this.Activities,
    required this.act,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return BlocBuilder<ActivityCubit, ActivityState>(
      builder: (context, state) {
        return ListView.separated(
scrollDirection: Axis.horizontal,
          itemCount: min(3, Activities.length),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                context.go(
                    '/activity/${Activities[index].id}/${state.selectedActivity.name}/$index');
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 48.0),
                child: Container(
                  height: mediaQuery.size.height / 7,
                  width: mediaQuery.size.width / 1.3,
                  decoration: ActivityDecoration,
                  child: Stack(children: [
                    images(
                        mediaQuery,
                        Activities,
                        index,
                        mediaQuery.size.height / 5.2,
                        mediaQuery.size.width / 1.1),
                    // Widget above the background
                    PosCard(mediaQuery, Activities, index),

                    details(mediaQuery, Activities, index, context),
                    ButtonComponent(
                        Activities: Activities,
                        index: index,
                        top: mediaQuery.size.height / 3.1,
                        left: mediaQuery.size.width / 14,
                        mediaQuery: mediaQuery,
                        act: act)
                  ]),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 20,
            );
          },
        );
      },
    );
  }
}

ClipRRect images(mediaQuery, List<Activity> activity, int index, double height,
        double width) =>
    activity[index].CoverImages.isNotEmpty
        ? ClipRRect(
            borderRadius: ActivityRaduis,
            child: Container(
                height: height,
                width: width,
                color: Colors.grey,
                child: CachedNetworkImageWidget(
                  item: activity[index].CoverImages[0],
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

Positioned details(MediaQueryData mediaQuery, List<Activity> activity,
        int index, BuildContext context) =>
    Positioned(
      top: mediaQuery.size.height / 4.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: BlocBuilder<localeCubit, LocaleState>(
          builder: (context, state) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Text(
                      "${DateFormat('dd MMMM yyyy', state.locale == const Locale("en") ? 'en_US' : 'fr_FR').format(activity[index].ActivityBeginDate)} à ${DateFormat('HH:mm').format(activity[index].ActivityBeginDate)}",
                      style: PoppinsNorml(
                          mediaQuery.devicePixelRatio * 4.5, textColorBlack),
                    ),
                  ),
                  SizedBox(
                      width: mediaQuery.size.width,
                      child: Text(
                        activity[index].name,
                        overflow: TextOverflow.ellipsis,
                        style: PoppinsSemiBold(mediaQuery.devicePixelRatio * 5,
                            textColorBlack, TextDecoration.none),
                      )),
                  SizedBox(
                      width: mediaQuery.size.width,
                      child: Text(
                        activity[index].ActivityAdress,
                        overflow: TextOverflow.ellipsis,
                        style: PoppinsLight(
                          activity[index].ActivityAdress.length < 20
                              ? mediaQuery.devicePixelRatio * 5
                              : mediaQuery.devicePixelRatio * 4,
                          textColorBlack,
                        ),
                      )),
                  SizedBox(
                      child: Text(
                    "${activity[index].Participants.length}  Participants",
                    style: PoppinsNorml(
                      mediaQuery.devicePixelRatio * 4,
                      textColorBlack,
                    ),
                  )),
                ],
              ),
            );
          },
        ),
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
                  activity[index]
                      .ActivityBeginDate
                      .day
                      .toString()
                      .padLeft(2, '0'),
                  style: PoppinsSemiBold(18, PrimaryColor, TextDecoration.none),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  DateFormat('MMM').format(activity[index].ActivityBeginDate),
                  style: PoppinsNorml(15, textColorBlack),
                ),
              ),
            ],
          ),
        ),
      ),
    );
