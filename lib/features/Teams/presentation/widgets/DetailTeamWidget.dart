import 'dart:convert';
import 'dart:developer';

import 'package:circle_progress_bar/circle_progress_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

import 'package:intl/intl.dart';

import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';

import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';

import 'package:jci_app/features/Teams/presentation/widgets/TaskImpl.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TaskWidget.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TeamComponent.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TeamImpl.dart';
import 'package:jci_app/features/Teams/presentation/widgets/funct.dart';


import '../../../../core/app_theme.dart';

import '../../../Home/presentation/bloc/PageIndex/page_index_bloc.dart';

import '../../../Home/presentation/widgets/Functions.dart';
import '../../../auth/domain/entities/Member.dart';
import '../../domain/entities/Team.dart';
import '../bloc/TaskFilter/taskfilter_bloc.dart';
import 'MembersTeamSelection.dart';

import 'TaskComponents.dart';
import 'TeamWidget.dart';

class TeamDetailWidget extends StatefulWidget {
  final Team team;

  final TextEditingController taskController;

  TeamDetailWidget({Key? key, required this.team, required this.taskController})
      : super(key: key);

  @override
  State<TeamDetailWidget> createState() => _TeamDetailWidgetState();
}

class _TeamDetailWidgetState extends State<TeamDetailWidget> {
  @override
  void initState() {

    log(widget.team.toString());
    // TODO: implement initState
    super.initState();
  }
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: mediaQuery.size.width/.8,
                      child: Header(context, mediaQuery)),
                ),



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
                          mediaQuery.devicePixelRatio*6, textColorBlack, TextDecoration.none),),
state.tasks.isEmpty?SizedBox():
                      buillLinkedtext(mediaQuery,widget.team),

                    ],
                  ),
                ),
                Column(


                  children: [
                    TaskAddField(widget.taskController, widget.team.id),

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
                          widget.team, mediaQuery, widget.taskController),
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
            return SingleChildScrollView(


                child: BottomTaskSheet(mediaQuery, state.tasks,team));
          });
        },
            child: Text("Show More",
              style: PoppinsSemiBold(
                  mediaQuery.devicePixelRatio*5, PrimaryColor, TextDecoration.underline),));
      },
    );
  }

  SizedBox description(mediaQuery, BuildContext context) {

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
                  buildText("Members", mediaQuery),
                  BlocBuilder<GetTeamsBloc, GetTeamsState>(
  builder: (context, state) {
    return SizedBox(
      width: mediaQuery .size.width/1.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
      
                        GestureDetector(
                          onTap: () {
                            TeamMembersShett(context, mediaQuery);},
                          child: membersTeamImage(
                              context, mediaQuery, widget.team.Members.length, widget.team.Members,30,40),
                        ),
                        buildAddButton((){
      
      
      
                        })
                      ],
                    ),
    );
  },
),
                ],
              ),


            ],
          ),
Column(
  mainAxisAlignment: MainAxisAlignment.start,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  buildText("Description", mediaQuery),
              SingleChildScrollView(
                child: Text(widget.team.description, textAlign: TextAlign.justify,
                  style: PoppinsRegular(
                    mediaQuery.devicePixelRatio * 4, textColorBlack,) ,),
              ),
  ],
),

        ],
      ),
    );
  }

  Future<dynamic> TeamMembersShett(BuildContext context, mediaQuery,) {
    return showModalBottomSheet(

                            showDragHandle: true,
                            context: context,
                            builder: (context) {
                              log(Member.toMember(widget.team.Members[0]).toString());
                              return SizedBox(
                                height: mediaQuery.size.height / 1.5,
                                width: mediaQuery.size.width,
                                child: SingleChildScrollView(

                                child: Padding(
                                  padding:paddingSemetricVerticalHorizontal(h: 14),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:[
                                      Padding(
                                        padding:paddingSemetricHorizontal(),
                                        child: Text("Board members ( ${widget.team.Members.length} )",style: PoppinsSemiBold(17, textColorBlack, TextDecoration.none),),
                                      ),
                                      SeachMemberWidget(mediaQuery, context,(value){},false),
                                      Padding(
                                        padding: paddingSemetricVertical(),
                                        child: SizedBox(
                                                                            height: mediaQuery.size.height/1.5,
                                          width: mediaQuery.size.width,
                                          child: TeamMembers(),
                                        ),
                                      )
                                    ]
                                  ),
                                ),
                                ),
                              );
                      });
  }

  ListView TeamMembers() {
    return ListView.separated(
                                            itemBuilder: (context,index){
                                          return     Padding(
                                            padding:paddingSemetricHorizontal(h: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                imageWidget(Member.toMember(widget.team.Members[widget.team.Members.length-index-1])),
                                                Member.toMember(widget.team.Members[widget.team.Members.length-index-1]).id!= Member.toMember(widget.team.TeamLeader[0]).id?
                                                Row(
                                                  children: [
                                                    Text("Member",style: PoppinsSemiBold(17, textColorBlack, TextDecoration.none),),
                                                    SizedBox(width: 10,),
                                                    TextButton(onPressed: () {
                                                      context.read<GetTeamsBloc>().add(UpdateTeamMember(fields: {"teamid":widget.team.id,"memberid":
                                                      Member.toMember(widget.team.Members[widget.team.Members.length-index-1]).id.toString(),"Status":"kick"}));
                                                    }, child: Text("kick",style: PoppinsRegular(17, Colors.red, ),))
                                                  ],
                                                ):
                                                Text("Admin",style: PoppinsSemiBold(17, textColorBlack, TextDecoration.none),),
                                              ],
                                            ),
                                          );
                                            }, separatorBuilder: (context,int){
                                          return SizedBox(height: 10,);
                                        }, itemCount: widget.team.Members.length);
  }

  Widget ProgessBar(MediaQueryData mediaQuery, BuildContext context,) {


    return BlocBuilder<GetTaskBloc, GetTaskState>(

      builder: (context, state) {    final  sasks = state.tasks.where((element) => !element['isCompleted']);
        double containerWidth = MediaQuery
          .of(context)
          .size
          .width / (state.tasks.length*1.2);
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
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    BackButton(onPressed: () {
                      GoRouter.of(context).go('/home');
                      context.read<GetTaskBloc>().add(resetevent());

                      context.read<TaskVisibleBloc>().add(changePrivacyEvent(Privacy.Primary));
                      context.read<GetTeamsBloc>().add(GetTeams(isPrivate: false,isUpdated: ste.isUpdated));
                      context.read<TaskVisibleBloc>().add(ChangeIsUpdatedEvent(ste.isUpdated));

                      context.read<TaskfilterBloc>().add(filterTask([]));

                    },),
                    SizedBox(
                      width: mediaQuery.size.width / 1.3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child:


                        ste.WillAdded ? Text("Add Task", style: PoppinsSemiBold(
                            mediaQuery.devicePixelRatio * 5, textColorBlack,
                            TextDecoration.none),) : ste.WillDeleted ? Text("Delete Task", style: PoppinsSemiBold(
                            mediaQuery.devicePixelRatio * 5, textColorBlack,
                            TextDecoration.none),) :

                        Row(

                            children: [
                              ImageCard(mediaQuery, widget.team,mediaQuery.size.height / 20.5,),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0),
                                child: SizedBox(
                                  width: mediaQuery.size.width /3,
                                  child: Text(widget.team.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: PoppinsSemiBold(
                                      mediaQuery.devicePixelRatio * 4,
                                      textColorBlack, TextDecoration.none),),
                                ),
                              ),
                              Container(
                                height: 20,
                                width: 20,

                                decoration: BoxDecoration(
                                  color:! widget.team.status  ? Colors.red : Colors.green,
                                  shape: BoxShape.circle,

                                ),

                              ),



                              IconButton(icon:Icon(Icons.more_vert, color: textColorBlack,), onPressed: () {

                                eleteUpdateTeamSHeet(context, mediaQuery);

                              },),

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

  void eleteUpdateTeamSHeet(BuildContext context, mediaQuery) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: mediaQuery.size.height / 3,
            width: double.infinity,
            child: ModelShowBottomActions(mediaQuery, context),
          );
        });
  }

  Column ModelShowBottomActions(mediaQuery, BuildContext context) {
    return Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [


                                            actionTeamRow(mediaQuery, TeamAction.Exit, Icons.exit_to_app, 'Exit ', () => null),


                                            actionTeamRow(mediaQuery, TeamAction.Upload, Icons.edit, "Update", () async{
                                              context.read<TaskVisibleBloc>().add(ChangeImageEvent(widget.team.CoverImage));
                                              final  image=  await  convertBase64ToXFile(widget.team.CoverImage);
                                              //log("kkkkkkkkkkkk${image!.path}");
                                              if (!mounted) return;
                                              context.go('/CreateTeam?team=${jsonEncode(widget.team.toJson())}&&image=${image}');
                                              context.read<TaskVisibleBloc>().add(ChangeImageEvent( image!.path));

                                            })

                                            ,actionTeamRow(mediaQuery, TeamAction.delete, Icons.delete, "Delete", () {
                                              context.read<GetTeamsBloc>().add(DeleteTeam( widget.team.id));
                                              context.read<TaskVisibleBloc>().add(ChangeIsUpdatedEvent(true));

                                            }),

                                            ]);
  }
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


Widget ImageCard(mediaQuery, Team team,double height) =>
    team.CoverImage.isNotEmpty
        ? ClipRRect(
        borderRadius: BorderRadius.circular(100),


        child: Image.memory(
          base64Decode(team.CoverImage),
          fit: BoxFit.cover,
          height:height,
          width: height


        ))
        : ClipRRect(

      borderRadius: BorderRadius.circular(100),

      child: Container(
        height: height,
        width: height,
        color: backgroundColored,
          child: Image.asset("assets/images/jci.png", fit: BoxFit.contain,)
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