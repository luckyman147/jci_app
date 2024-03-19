import 'dart:convert';

import 'package:circle_progress_bar/circle_progress_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jci_app/core/util/snackbar_message.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskActions/task_actions_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';

import 'package:jci_app/features/Teams/presentation/widgets/TaskImpl.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TaskWidget.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TeamComponent.dart';



import '../../../../core/app_theme.dart';

import '../../../Home/presentation/bloc/PageIndex/page_index_bloc.dart';

import '../../domain/entities/Team.dart';
import 'MembersTeamSelection.dart';

import 'TeamWidget.dart';

class TeamDetailWidget extends StatelessWidget {
  final Team team;
  final TextEditingController taskController ;

  TeamDetailWidget({Key? key, required this.team, required this.taskController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String date = team.event['ActivityEndDate']!;
    final parse = DateTime.parse(date);
    final mediaQuery = MediaQuery.of(context);
    return BlocListener<TaskActionsBloc, TaskActionsState>(

  listener: (context, state) {
if (state is TaskAdded){
  SnackBarMessage.showSuccessSnackBar(message: state.message, context: context);
  context.read<GetTaskBloc>().add(GetTasks(id: '${team.id}'));
}
else if (state is ErrorMessage){
  SnackBarMessage.showErrorSnackBar(message: state.message, context: context);
}
  },
  child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: SingleChildScrollView(
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Header(context,mediaQuery),

            Padding(
              padding:  EdgeInsets.symmetric(horizontal: mediaQuery.size.width/20,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                description(mediaQuery)  ,
Progress(team,mediaQuery),

                ],
              ),
            ),
            Padding(

              padding:  EdgeInsets.symmetric(horizontal: 18.0,vertical: mediaQuery.size.height/30),
              child: Circle(team, parse,mediaQuery,context),
            ),


            Padding(
              padding:  EdgeInsets.symmetric(horizontal: mediaQuery.size.width/20,),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [

                  Text('Tasks', style: PoppinsSemiBold(
                      20, textColorBlack, TextDecoration.none),),


                ],
              ),
            ),
            Column(


              children: [
                TaskAddField(taskController,team.id),
                Padding(
                  padding: paddingSemetricHorizontal(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(onPressed: (){
                        showModalBottomSheet(context: context, builder: (context) {
                          return BottomTaskSheet(mediaQuery);

                        });


                      },
                          child: Text("Show More",
                            style: PoppinsSemiBold(17, PrimaryColor, TextDecoration.underline),)),
                    ],
                  ),
                )
                ,SizedBox(

                  height: mediaQuery.size.height/1.5 ,
                  child: GetTasksWidget(team.id,mediaQuery,taskController),
                ),

              ],
            ),
          ],

        )

        ,),
    ),
);
    
    
    
    
    
    
    
    
    
  }SizedBox description(mediaQuery)=>SizedBox(
    height: mediaQuery.size.height / 4.5,
    width: mediaQuery.size.width / 2.5,

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,

      children: [


        team.TeamLeader.isNotEmpty?
        Text("By ${     team.TeamLeader[0]["firstName"]}",
          style: PoppinsRegular(mediaQuery .devicePixelRatio*6, textColorBlack,),):SizedBox(),

        Text(team.description,
          style: PoppinsRegular(11, textColor,),),

      ],
    ),
  );
  Widget Header(BuildContext contex,mediaQuery) =>
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


                    ste.WillAdded?Text("Add Task",style: PoppinsSemiBold(
                        mediaQuery.devicePixelRatio*6, textColorBlack, TextDecoration.none),):

                    Row(

                        children:[
                          ImageCard(mediaQuery, team),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(team.name, style: PoppinsSemiBold(
                                mediaQuery.devicePixelRatio*5, textColorBlack, TextDecoration.none),),
                          ),
                          Icon(Icons.more_vert,color: textColorBlack,),

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


Widget Circle(Team team, DateTime parse,MediaQueryData mediaQuery,BuildContext context) =>
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: mediaQuery.size.width / 2.3,
            decoration: BoxDecoration(
                color: BackWidgetColor,
                borderRadius: BorderRadius.all(Radius.circular(10))),

            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween
                 , children: [
                    Icon(Icons.timer,color: Colors.red,),
                    Text('Deadline', style: PoppinsNorml(14, textColorBlack,),),
                    Text(DateFormat('MMM,dd').format(parse),
                      style: PoppinsSemiBold(
                          14, textColorBlack, TextDecoration.none),),
                  ]
              ),
            ),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 8.0),
            child: membersTeamImage(context, mediaQuery, team.Members.length, team.Members),
          )



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



Widget Progress (Team team,MediaQueryData mediaQuery)=> SizedBox(
  height: mediaQuery.size.height / 5.5,
  child: CircleProgressBar(
    foregroundColor: PrimaryColor,
    backgroundColor: textColor,
    strokeWidth: 10,
    value: team.tasks.isEmpty
        ? 0
        : calculateSumCompletedTasks(
        team.tasks) /
        team.tasks.length,
    child: Align(
      alignment: Alignment.center,
      child: AnimatedCount(
        style: PoppinsSemiBold(17, textColorBlack,
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
);



Widget membersTeamImage(BuildContext context, MediaQueryData mediaQuery,int length,List<dynamic> items)=>Row(

  children: [
    for (var i = 0; i < (length > 3? 2 : length); i++)

      PhotoContainer(items, i),
    if (length> 3)
      alignPhoto(length),

  ],
);

Padding PhotoContainer(List<dynamic> item, int i) {
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
                30,15)),
      ),
    );
}

Align alignPhoto(int number) {
  return Align(
      widthFactor: .5,
      child: NophotoContainer(number),
    );
}

Container NophotoContainer(int number) {
  return Container(
        height: 40,
        width: 40,
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
            style: PoppinsLight(9, textColorWhite),
          ),
        ),
      );
}