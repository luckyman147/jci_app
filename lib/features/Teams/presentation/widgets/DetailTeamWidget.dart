import 'dart:convert';

import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import '../../domain/entities/Team.dart';
import 'TeamWidget.dart';

class TeamDetailWidget extends StatelessWidget {
  final Team team;

  const TeamDetailWidget({Key? key, required this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String date = team.event['ActivityEndDate']!;
    final parse = DateTime.parse(date);
    final mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(
      child:
      Column(
        children: [

          Row(
            children: [
              Column(
                children: [
                  Text(team.name, style: PoppinsSemiBold(
                      20, textColorBlack, TextDecoration.none),),
                  Text(team.description,
                    style: PoppinsRegular(14, textColorBlack,),),
                ],
              ),
              ImageCard(mediaQuery, team)

            ],
          ),
          Circle(team, parse),

          Column(
              children: [
                Text('Team Members', style: PoppinsSemiBold(
                    20, textColorBlack, TextDecoration.none),),
                Row()
              ]
          )

        ],
      )

      ,);
  }
}


Widget Circle(Team team, DateTime parse) =>
    Row(
        children: [
          Container(
            decoration: BoxDecoration(
                color: BackWidgetColor,
                borderRadius: BorderRadius.all(Radius.circular(10))),

            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.timer),
                  Text('Deadline', style: PoppinsNorml(14, textColorBlack,),),
                  Text(DateFormat('MMM,dd').format(parse),
                    style: PoppinsSemiBold(
                        14, textColorBlack, TextDecoration.none),),
                ]
            ),
          ),
          SizedBox(
            height: 50,
            child: CircleProgressBar(
              foregroundColor: Colors.blue,
              backgroundColor: Colors.black12,
              strokeWidth: 10,
              value: team.tasks.isEmpty
                  ? 0
                  : calculateSumCompletedTasks(
                  team.tasks) /
                  team.tasks.length,
              child: Align(
                alignment: Alignment.center,
                child: AnimatedCount(
                  style: PoppinsSemiBold(15, textColorBlack,
                      TextDecoration.none),
                  count: team.tasks.isEmpty
                      ? 0
                      : calculateSumCompletedTasks(
                      team.tasks) /
                      team.tasks.length,
                  unit: '%',
                  duration: Duration(milliseconds: 500),
                ),
              ),
            ),
          ),

        ]
    );


Widget Header(BuildContext context) =>
    BlocBuilder<PageIndexBloc, PageIndexState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackButton(onPressed: () {
              GoRouter.of(context).go('/home');
            },),
            Container(
              decoration: BoxDecoration(

                  color: SecondaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "In progress",
                    style: PoppinsSemiBold(17, textColorWhite, TextDecoration.none),
                  ),
                ),
              ),

            ),
            Container(

              decoration:
              BoxDecoration(color: BackWidgetColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: SvgPicture.string(
                DotsSvg,
                color: Colors.black,
                width: 20,
                height: 40,
              ),
            ),
          ],
        );
      },
    );

Widget ImageCard(mediaQuery, Team team) =>
    team.CoverImage.isNotEmpty
        ? ClipRRect(

        child: Container(
          color: textColor,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            child: Image.memory(
              base64Decode(team.CoverImage),
              fit: BoxFit.cover,
              height: mediaQuery.size.height / 4.5,

            ),
          ),
        ))
        : ClipRRect(

      child: Container(
        height: mediaQuery.size.height / 4.5,

        color: textColor,
      ),
    );
