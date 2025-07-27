import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:jci_app/core/widgets/loading_widget.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';

import '../../../../../../core/app_theme.dart';
import '../../../../../../core/route/app_router.dart';
import '../../../../domain/entities/task/Task.dart';
import '../../../../domain/entities/Team/Team.dart';
import '../Detail/DetailTeamComponents.dart';
import '../../member/MembersTeamSelection.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
class TeamWidget extends StatelessWidget {
  final List<Team> teams;
  final ScrollController scrollController;
  final bool hasReachedMax;
final GetTeamsState state;
final bool isPrivate;
  const TeamWidget({
    Key? key,

    required this.state,
    required this.isPrivate ,
    required this.teams, required this.scrollController, required this.hasReachedMax
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return ListView.separated(
        controller: scrollController,
        itemBuilder: (ctx, index) {
if (index < teams.length) {
  return body(teams, index, mediaQuery, context);
}
          return

           TextButton(
              style:
              ElevatedButton.styleFrom(
                side: BorderSide(color: ColorsApp.textColorBlack),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),

                ),
              )
              ,
              onPressed: (){
                context.read<GetTeamsBloc>().add(GetMoreTeams(state.lastDocument,isPrivate:isPrivate));

              }, child: Text("Load More".tr(context),style: PoppinsNorml(18.sp, ColorsApp.textColorBlack),));

        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 20,
          );
        },
        itemCount: hasReachedMax ? teams.length : teams.length + 1);
  }
}

Widget body(List<Team> teams, int index, MediaQueryData mediaQuery,
    BuildContext context, ) =>
    SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
              horizontal: mediaQuery.size.width / 13),
          child: InkWell(
            splashColor: Colors.grey,
            onTap: () {
              context.navigateTo(
                  TeamDetailsRoute(
                      id: teams[index].meta.id,
                      index: index,
                      ));


              context.read<GetTeamsBloc>().add(GetTeamById({"id": teams[index].meta.id,"isUpdated":true}));
            },
            child: Container(
              height: mediaQuery.size.height / 4.5,
              width: mediaQuery.size.width / 1,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: textColorBlack, width: 2),
              ),
              child: BlocBuilder<GetTaskBloc, GetTaskState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(

                      children: [

                        Padding(
                          padding: paddingSemetricHorizontal(h: 10),
                          child: DeatailsTeamComponent.ImageCard(mediaQuery, teams[index].meta.coverImage, mediaQuery.size.height / 12.5,),
                        ),

                        SingleChildScrollView(

                          scrollDirection: Axis.horizontal,
                          child: details(teams, index,mediaQuery),
                        ),

                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ));


Widget details(List<Team> teams, int index,MediaQueryData mediaQuery) =>
    Column(

      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: mediaQuery.size.width / 2.5,
          child: Text(
            teams[index].meta.name,
            overflow: TextOverflow.ellipsis,
            style: PoppinsSemiBold(
                18, textColorBlack, TextDecoration.none),
          ),
        ),
        SizedBox(
          width: mediaQuery.size.width / 1.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleProgess(teams, index,mediaQuery),
              IsPublic(teams[index].meta.status)
            ],
          ),
        ),
        Padding(
          padding: paddingSemetricVertical(v:15),
          child: SizedBox(
            width: mediaQuery.size.width / 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween,
              children: [
                TaskRow(teams, index),
                Row(
                  children: [
                    Padding(
                      padding: paddingSemetricHorizontal(),
                      child: Images(teams, index),
                    ),


                  ],
                )
              ],
            ),
          ),
        ),

        // eventRow(mediaQuery, teams, index),

      ],
    );

Padding IsPublic(bool status) {
  return Padding(
    padding:paddingSemetricHorizontal(),
    child: Container(

      decoration: BoxDecoration(
        color: !status?Colors.green:Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(!status?"Public":"Private",style: PoppinsRegular(14, textColorWhite),),
      ),
    ),
  );
}

Row eventRow(MediaQueryData mediaQuery, List<Team> teams, int index) {
  return Row(
    children: [
      const Icon(Icons.event,color: SecondaryColor,),
      const SizedBox(width: 5,),
      SizedBox(
        width:mediaQuery.size.width/5,
        child: Text(
          teams[index].meta.event!.activityBasics.name,
          overflow: TextOverflow.ellipsis,
          style: PoppinsRegular(
            14,
            textColorBlack,
          ),
        ),
      ),
    ],
  );
}


int calculateSumCompletedTasks(List<Map<String, dynamic>> tasks) {
  return tasks
      .where((task) => task['isCompleted'] == true)
      .fold(0, (sum, task) => sum + 1);
}int calculateCompletedTasks(List<Tasks> tasks) {
  return tasks
      .where((task) => task.isCompleted == true)
      .fold(0, (sum, task) => sum + 1);
}

Widget Images(List<Team> teams, int index) =>
    Row(
      children: [
        for (var i = 0;
        i <
            (teams[index].members.members
                .length >
                3
                ? 2
                : teams[index].members.members
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
                  child:


                  MemberTeamSelection.   photo(
                      teams[index].members.members[i].Images[0],
                      25, 100))),
        if (teams[index].members.members.length > 3)
          Container(
            height: 30,
            width: 30,
            decoration: const BoxDecoration(
              color: backgroundColored,
              shape: BoxShape.circle,
            ),
            // Customize the container as needed
            child: Align(
              widthFactor: .5,
              child: Center(
                child: Text(
                  '+ ${teams[index].members.members.length - 3} ',
                  style: PoppinsLight(
                      15, textColorBlack),
                ),
              ),
            ),
          ),
      ],
    );


Widget CircleProgess(List<Team> teams, int index,MediaQueryData mediaQuery
    ) =>
    teams[index].members.teamLeader!.firstName.isNotEmpty
        ? SizedBox(
      width: mediaQuery.size.width / 3.5,
          child: Text(
                "By ${teams[index].members.teamLeader!.firstName} ${teams[index].members.teamLeader!.lastName}" ,
                overflow: TextOverflow.ellipsis,
                style: PoppinsSemiBold(
          17,
          textColor,
          TextDecoration.none,
                ),
              ),
        )
        : const SizedBox();

SizedBox progresscircle(List<Team> teams, int index) {
  double value = teams[index].stats.numberOfTasksTotal==0
          ? 0
          :
      teams[index].stats.numberOfTasksCompleted /  teams[index].stats.numberOfTasksTotal;
  return SizedBox(
    height: 90,
    child: CircleProgressBar(
      foregroundColor: Colors.blue,
      backgroundColor: Colors.black12,
      strokeWidth: 8,
      value: value,
      child: Align(
        alignment: Alignment.center,
        child: AnimatedCount(
          style: PoppinsSemiBold(17, textColorBlack,
              TextDecoration.none),
          count: value*100,
          unit: "%",
          duration: const Duration(milliseconds: 500),
        ),
      ),
    ),
  );
}

Widget TaskRow(List<Team> teams, int index) {
  return Container(
    decoration: BoxDecoration(
      color: textColorWhite,
      border: Border.all(color: BackWidgetColor, width: 2),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Flex(
          direction: Axis.horizontal,
          children: [
            const Icon(
              Icons.check_box_outlined,
              color: PrimaryColor,
              size: 20,
            ),
            Text(
              "${teams[index].stats.numberOfTasksCompleted}"
                  " / ${teams[index].stats.numberOfTasksTotal} ",
              style: PoppinsSemiBold(
                15,
                textColorBlack,
                TextDecoration.none,
              ),
            ),

          ]),

    ),
  );
}


Padding deadline(DateTime parse) =>
    Padding(
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


class TeamHomeWidget extends StatelessWidget {
  final List<Team> teams;


  const TeamHomeWidget({
    Key? key,
    required this.teams  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, index) {



          return SingleChildScrollView(
              child: InkWell(
                onTap: () {
              //    context.go('/TeamDetails/${teams[index].id}/$index');
                },
                child: Container(
                  width: mediaQuery.size.width /1.8,
                  height: mediaQuery.size.height/6,

                  decoration: BoxDecoration(

                  gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    index.isOdd ? SecondaryColor :
           PrimaryColor,

                    textColorWhite
                  ],
                  ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),

                        blurRadius: 7,
                        offset: const Offset(0, 1), // changes position of shadow
                      ),
                    ],

                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,

                      children: [
                        SizedBox(
                          width: mediaQuery.size.width / 2.4,
                          child: Text(
                            teams[index].meta.name,
                            overflow: TextOverflow.ellipsis,
                            style: PoppinsSemiBold(
                              16,
                              textColorWhite,
                              TextDecoration.none,
                            ),
                          ),
                        ),


                        Padding(
                          padding: paddingSemetricVertical(),
                          child: SizedBox(
                            width: mediaQuery.size.width / 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                TaskRow(teams, index),
                                Images(teams, index),

                              ],
                            ),
                          ),
                        ),


                        // eventRow(mediaQuery, teams, index),

                      ],
                    ),
                  ),
                ),
              )

          ) ;       },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            width: 20,
          );
        },
        itemCount:min(teams.length, 3));
  }
}