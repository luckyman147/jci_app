import 'dart:convert';

import 'package:circle_progress_bar/circle_progress_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jci_app/core/util/snackbar_message.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';

import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';

import 'package:jci_app/features/Teams/presentation/widgets/TaskImpl.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TaskWidget.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TeamComponent.dart';
import 'package:jci_app/features/Teams/presentation/widgets/funct.dart';


import '../../../../core/app_theme.dart';

import '../../../Home/presentation/bloc/PageIndex/page_index_bloc.dart';

import '../../domain/entities/Team.dart';
import 'MembersTeamSelection.dart';

import 'TeamWidget.dart';

class TeamDetailWidget extends StatelessWidget {
  final Team team;
  final TextEditingController taskController;

  TeamDetailWidget({Key? key, required this.team, required this.taskController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: SingleChildScrollView(
        child:
        BlocBuilder<GetTaskBloc, GetTaskState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Header(context, mediaQuery),

          /*      Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.size.width / 20,vertical: 10),
                  child: description(mediaQuery, context),
                ),*/

              state.tasks.isEmpty?SizedBox():
                Column(
                  children: [
                    buildProgressText(state),


                    Align(
                        alignment: Alignment.center,
                        child: ProgessBar(mediaQuery, context, )),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: mediaQuery.size.width / 20,vertical: 10),
                  child: description(mediaQuery, context),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.size.width / 20,),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [

                      Text('Tasks', style: PoppinsSemiBold(
                          20, textColorBlack, TextDecoration.none),),
state.tasks.isEmpty?SizedBox():
                      buillLinkedtext(mediaQuery,team),

                    ],
                  ),
                ),
                Column(


                  children: [
                    TaskAddField(taskController, team.id),
                    state.tasks.isEmpty?SizedBox():
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: paddingSemetricVerticalHorizontal(v: 10,h: 0),
                        child: myTaskButtons(),
                      ),
                    )
                    , SizedBox(

                      height: mediaQuery.size.height / 1.5,
                      child: GetTasksWidget(
                          team, mediaQuery, taskController),
                    ),

                  ],
                ),
              ],

            );
          },
        )

        ,),
    );
  }

  Align buildProgressText(GetTaskState state) {
    return Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:paddingSemetricHorizontal(h: 12),
                      child:   Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          state.tasks.isNotEmpty?      Icon(Icons.check_circle_outline, color: PrimaryColor, size: 20,):SizedBox()
                          ,Text("${calculateSumCompletedTasks(state.tasks)}/${state.tasks.length} ",
                            style: PoppinsRegular(16, textColorBlack),),
                        ],
                      ),
                    ),
                  );
  }

  BlocBuilder<GetTaskBloc, GetTaskState> buillLinkedtext(
      MediaQueryData mediaQuery,Team team) {
    return BlocBuilder<GetTaskBloc, GetTaskState>(
      builder: (context, state) {
        return TextButton(onPressed: () {
          showModalBottomSheet(

              showDragHandle: true,
              backgroundColor: textColorWhite,
              context: context, builder: (context) {
            return BottomTaskSheet(mediaQuery, state.tasks,team);
          });
        },
            child: Text("Show More",
              style: PoppinsSemiBold(
                  17, PrimaryColor, TextDecoration.underline),));
      },
    );
  }

  SizedBox description(mediaQuery, BuildContext context) {
    double maxHeight = 200; // Set the maximum height limit to 200
    double height = mediaQuery.size.height * (team.Members.length / 100);
    height = height > maxHeight ? maxHeight : height;
    String date = team.event['ActivityEndDate']!;
    final parse = DateTime.parse(date);
    return SizedBox(



      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,


        children: [


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  team.TeamLeader.isNotEmpty
                      ?
                  Text("By ${ team.TeamLeader[0]["firstName"]}",
                    style: PoppinsRegular(
                      mediaQuery.devicePixelRatio * 5, textColorBlack,),)
                      : SizedBox(),
                  membersTeamImage(
                      context, mediaQuery, team.Members.length, team.Members,30,40),
                ],
              ),

              Padding(

                padding: EdgeInsets.symmetric(

                    horizontal: 8.0,),
                child: Circle(team, parse, mediaQuery, context),
              ),
            ],
          ),
Column(
  mainAxisAlignment: MainAxisAlignment.start,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text("Description", style: PoppinsSemiBold( 14, textColorBlack, TextDecoration.none),),
              SingleChildScrollView(
                child: Text(team.description, textAlign: TextAlign.justify,
                  style: PoppinsRegular(
                    mediaQuery.devicePixelRatio * 4, textColor,) ,),
              ),
  ],
),

        ],
      ),
    );
  }

  Widget ProgessBar(MediaQueryData mediaQuery, BuildContext context,) {


    return BlocBuilder<GetTaskBloc, GetTaskState>(

      builder: (context, state) {    final  sasks = state.tasks.where((element) => !element['isCompleted']);
        double containerWidth = MediaQuery
          .of(context)
          .size
          .width / (state.tasks.length*1.1);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display containers for true values with red color
              ...state.tasks.where((element) => element['isCompleted']).toList().asMap().entries.map((entry) {
             if (entry.key == 0) {
                  // Apply border radius to the first container
                  return Container(
                    decoration: BoxDecoration(
                      color: PrimaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    width: containerWidth,
                    height: 10,
                  );
                } else {
                  // Don't apply border radius to the other containers
                  return Container(
                    decoration: BoxDecoration(
                      color: PrimaryColor,
                    ),
                    width: containerWidth,
                    height: 10,
                  );
                }
              }).toList(),
              // Display containers for false values with blue color
              ...state.tasks.where((element) => !element['isCompleted']).toList().asMap().entries.map((entry) {

                if (entry.key == sasks.length - 1) {
                  // Apply border radius to the last container
                  return Container(
                    decoration: BoxDecoration(
                      color: textColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    width: containerWidth,
                    height: 10,
                  );
                }







                else {
                  // Don't apply border radius to the other containers
                  return Container(
                    decoration: BoxDecoration(
                      color: textColor,
                    ),
                    width: containerWidth,
                    height: 10,
                  );
                }

              }).toList(),
            ],
          ),
        );
      },
    );
  }


  Widget Header(BuildContext contex, mediaQuery) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: BlocBuilder<PageIndexBloc, PageIndexState>(
          builder: (context, state) {
            return BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
              builder: (context, ste) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    BackButton(onPressed: () {
                      GoRouter.of(context).go('/home');
                      context.read<GetTaskBloc>().add(resetevent());
                    },),
                    SizedBox(
                      width: mediaQuery.size.width / 1.2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child:


                        ste.WillAdded ? Text("Add Task", style: PoppinsSemiBold(
                            mediaQuery.devicePixelRatio * 6, textColorBlack,
                            TextDecoration.none),) : ste.WillDeleted ? Text("Delete Task", style: PoppinsSemiBold(
                            mediaQuery.devicePixelRatio * 6, textColorBlack,
                            TextDecoration.none),) :

                        Row(

                            children: [
                              ImageCard(mediaQuery, team),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0),
                                child: Text(team.name, style: PoppinsSemiBold(
                                    mediaQuery.devicePixelRatio * 5,
                                    textColorBlack, TextDecoration.none),),
                              ),
                              Icon(Icons.more_vert, color: textColorBlack,),

                            ]
                        ),
                      ),
                    ),



                  ],
                );
              },
            );
          },
        ),
      );
}


Widget Circle(Team team, DateTime parse, MediaQueryData mediaQuery,
    BuildContext context) =>
    Column(

        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween
                , children: [
              Row(
                children: [
                  Icon(Icons.timer, color: Colors.red,),
                  Text('Deadline', style: PoppinsNorml(14, textColorBlack,),),
                ],
              ),
              Text(DateFormat('MMM,dd').format(parse),
                style: PoppinsSemiBold(
                    16, textColorBlack, TextDecoration.none),),
            ]
            ),
          ),


        ]
    );


Widget ImageCard(mediaQuery, Team team) =>
    team.CoverImage.isNotEmpty
        ? ClipRRect(
        borderRadius: BorderRadius.circular(100),


        child: Image.memory(
          base64Decode(team.CoverImage),
          fit: BoxFit.cover,
          height: mediaQuery.size.height / 20.5,
          width: mediaQuery.size.height / 20.5,


        ))
        : ClipRRect(

      borderRadius: BorderRadius.circular(100),

      child: Container(
        height: mediaQuery.size.height / 20.5,
        width: mediaQuery.size.height / 20.5,
        color: textColor,
      ),
    );


Widget Progress(Team team, MediaQueryData mediaQuery,
    List<Map<String, dynamic>> tasks) =>
    SizedBox(
      height: mediaQuery.size.height / 5.5,
      child: CircleProgressBar(
        foregroundColor: PrimaryColor,
        backgroundColor: textColor,
        strokeWidth: 10,
        value: team.tasks.isEmpty
            ? 0
            : calculateSumCompletedTasks(
            tasks) /
            team.tasks.length,
        child: Align(
          alignment: Alignment.center,
          child: AnimatedCount(
            style: PoppinsSemiBold(17, textColorBlack,
                TextDecoration.none),
            count: team.tasks.isEmpty
                ? 0
                : (calculateSumCompletedTasks(
                tasks) /
                team.tasks.length) * 100,
            unit: '%',
            duration: Duration(milliseconds: 500),
          ),
        ),
      ),
    );


Widget membersTeamImage(BuildContext context, MediaQueryData mediaQuery,
    int length, List<dynamic> items,double photoheight,double contHeight) =>
    Row(

      children: [
        for (var i = 0; i < (length > 3 ? 2 : length); i++)

          PhotoContainer(items, i,photoheight),
        if (length > 3)
          alignPhoto(length,contHeight),

      ],
    );

Padding PhotoContainer(List<dynamic> item, int i,double height) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 3.0),
    child: Align(
      widthFactor: .5,
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: textColorWhite,
                width: 5),
            shape: BoxShape.circle,
          ),
          child: photo(
              item[i]["Images"],
              height, 15)),
    ),
  );
}

Align alignPhoto(int number,double height) {
  return Align(
    widthFactor: .5,
    child: NophotoContainer(number,height),
  );
}

Container NophotoContainer(int number,double height) {
  return Container(
    height: height,
    width: height,
    decoration: BoxDecoration(
      border: Border.all(
          color: textColorWhite,
          width: 5),
      color: PrimaryColor,

      shape: BoxShape.circle,
    ),
    // Customize the container as needed
    child: Center(
      child: Text(
        '+ ${number - 2} ',
        style: PoppinsLight(11, textColorWhite),
      ),
    ),
  );
}