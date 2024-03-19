import 'dart:developer';

import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jci_app/core/widgets/loading_widget.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';

import '../../../../core/app_theme.dart';
import '../../domain/entities/Team.dart';
import 'MembersTeamSelection.dart';

class TeamWidget extends StatelessWidget {
  final List<Team> teams;
  final ScrollController scrollController;
final bool hasReachedMax;
  const TeamWidget({
    Key? key,
    required this.teams, required this.scrollController, required this.hasReachedMax
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return ListView.separated(
      controller:scrollController ,
        itemBuilder: (ctx, index) {

          String date = index >= teams.length?DateTime.now().toString(): teams[index].event['ActivityEndDate']!;
          final parse = DateTime.parse(date);
          return index>= teams.length?
              LoadingWidget():body(teams, index, mediaQuery, context, parse);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 20,
          );
        },
        itemCount:hasReachedMax?teams.length:teams.length+1);
  }
}

Widget body(List<Team> teams, int index,MediaQueryData mediaQuery,BuildContext context,DateTime parse)=> SingleChildScrollView(
    child: Padding(
      padding: EdgeInsetsDirectional.symmetric(
          horizontal: mediaQuery.size.width / 13),
      child: InkWell(
        onTap: () {

          context.go('/TeamDetails/${teams[index].id}');

        },
        child: Container(
          height: mediaQuery.size.height / 5,
          width: mediaQuery.size.width / 1,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: BackWidgetColor, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          details(teams, index),
                          Images(teams, index) ,
                          //pading
                          deadline(parse),
                        ]),
                  ),
                ),
                CircleProgess(teams, index)
              ],
            ),
          ),
        ),
      ),
    ))  ;


Widget details(List<Team> teams, int index)=>Column(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      teams[index].name,
      style: PoppinsSemiBold(
          18, textColorBlack, TextDecoration.none),
    ),
    !teams[index].TeamLeader.isEmpty
        ? Text(
      "By ${teams[index].TeamLeader[0]["firstName"]}",
      style: PoppinsRegular(
        14,
        textColorBlack,
      ),
    )
        : SizedBox(),
    Text(
      teams[index].event['name']!,
      style: PoppinsRegular(
        14,
        textColorBlack,
      ),
    ),
  ],
);









int calculateSumCompletedTasks(List<Map<String, dynamic>> tasks) {
  return tasks
      .where((task) => task["isCompleted"] == true)
      .fold(0, (sum, task) => sum + 1);
}

Widget Images( List<Team >  teams , int index)=>  Row(
  children: [
    for (var i = 0;
    i <
        (teams[index].Members
            .length >
            4
            ? 3
            : teams[index].Members
            .length);
    i++)
      Align(
          widthFactor: .6,
          child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: textColorWhite,
                    width: 5),
                shape: BoxShape.circle,
              ),
              child: photo(
                  teams[index].Members[i]
                  ['Images'] as List<dynamic>,
                  30,100))),
    if (teams[index].Members.length > 4)
      Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: PrimaryColor,
          shape: BoxShape.circle,
        ),
        // Customize the container as needed
        child: Align(
          widthFactor: .4,
          child: Center(
            child: Text(
              '+ ${teams[index].Members.length - 4} ',
              style: PoppinsLight(
                  18, textColorWhite),
            ),
          ),
        ),
      ),
  ],
);










Widget CircleProgess(List<Team > teams ,int index)=>           Padding(
  padding: const EdgeInsets.symmetric(horizontal: 8.0),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      SizedBox(
        height: 110,
        child: CircleProgressBar(
          foregroundColor: Colors.blue,
          backgroundColor: Colors.black12,
          strokeWidth: 10,
          value: teams[index].tasks.isEmpty
              ? 0
              : calculateSumCompletedTasks(
              teams[index].tasks) /
              teams[index].tasks.length,
          child: Align(
            alignment: Alignment.center,
            child: AnimatedCount(
              style: PoppinsSemiBold(20, textColorBlack,
                  TextDecoration.none),
              count: teams[index].tasks.isEmpty
                  ? 0
                  : calculateSumCompletedTasks(
                  teams[index].tasks) /
                  teams[index].tasks.length,
              unit: '%',
              duration: Duration(milliseconds: 500),
            ),
          ),
        ),
      ),
      Row(children: [
        Icon(
          Icons.check_circle,
          color: PrimaryColor,
          size: 20,
        ),
        Text(
          " ${calculateSumCompletedTasks(teams[index].tasks)} tasks",
          style: PoppinsLight(
            14,
            textColorBlack,
          ),
        ),
      ])
    ],
  ),
);


Padding deadline(DateTime parse)=> Padding(
  padding:
  const EdgeInsets.symmetric(vertical: 8.0),
  child: Row(
    children: [
      const Icon(
        Icons.calendar_month_rounded,
        color: textColorBlack,
        size: 20,
      ),
      Text(
        DateFormat('MMM,dd, yyyy')
            .format(parse),
        style: PoppinsRegular(
          14,
          textColorBlack,
        ),
      ),
    ],
  ),
);