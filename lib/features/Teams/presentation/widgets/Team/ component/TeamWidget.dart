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
import '../../../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../../../../domain/entities/TeamUser.dart';
import '../../../../domain/entities/task/Task.dart';
import '../../../../domain/entities/Team/Team.dart';
import '../Detail/DetailTeamComponents.dart';
import '../../member/MembersTeamSelection.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';

import 'JoinTeamDialog.dart';
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
            onTap: () async{
              final user= context.read<MembersBloc>().state.user!;
              final teamuser=TeamUser(user);

              if (teams [index].members.members.indexWhere((test)=>test.user.id==user.id)!=-1) {
                context.navigateTo(
                    TeamDetailsRoute(
                      id: teams[index].meta.id,
                      index: index,
                    ));


                context.read<GetTeamsBloc>().add(GetTeamById(
                    {"id": teams[index].meta.id, "isUpdated": true}));
              }
              else {
                showDialog(
                  context: context,
                  builder: (_) {
                    var meta2 = teams [index].meta;
                    return JoinTeamDialog(
                    teamName: meta2.name,
                    requiresPin: meta2.status == true,
                    onJoin: (


                        ) {
                      context.navigateTo(
                          TeamDetailsRoute(
                            id: teams[index].meta.id,
                            index: index,
                          ));


                      context.read<GetTeamsBloc>().add(GetTeamById(
                          {"id": teams[index].meta.id, "isUpdated": true}));
                      // Handle join logic, use pin if needed
                    }, user: teamuser, TeamId: meta2.id,
                  );
                  },
                );
              }

              },
            child: Container(

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: ColorsApp.BackWidgetColor, width: 2),
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


Widget details(List<Team> teams, int index,MediaQueryData mediaQuery) {
  final totalTasks = teams[index].stats.numberOfTasksTotal;
  final completedTasks = teams[index].stats.numberOfTasksCompleted;


  final progress = totalTasks > 0 ? completedTasks / totalTasks : 0;
  return Column(

    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: mediaQuery.size.width / 1.8,
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Text(
              teams[index].meta.name,
              overflow: TextOverflow.ellipsis,
              style: PoppinsSemiBold(
                  18, textColorBlack, TextDecoration.none),
            ),
            IsPublic(teams[index].meta.status)
          ],
        ),
      ),

      // eventRow(mediaQuery, teams, index),
      SizedBox(

        width: mediaQuery.size.width / 2,

        child:
      Padding(
        padding: const EdgeInsets.only(top: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: progress.toDouble(),
              minHeight: 6,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(ColorsApp.PrimaryColor),
              borderRadius: BorderRadius.circular(4),
            ),
            SizedBox(height: 4),
            Text(
              "$completedTasks / $totalTasks tasks completed",
              style: PoppinsNorml( 12,ColorsApp.textColorBlack),
            ),
          ],
        ),
      ),),

      Padding(
        padding: paddingSemetricVertical(v: 2),
        child: SizedBox(
          width: mediaQuery.size.width / 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween,
            children: [

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
    ],
  );
}
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
          teams[index].meta.event!.name,
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
      .where((task) => task.meta.status == TaskCompletionStatus.Completed)
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
                      teams[index].members.members[i].user.Images[0],
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
    required this.teams,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(

      itemCount: min(teams.length, 3),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, index) {
        final team = teams[index];
        final isPublic = !team.meta.status;
        final totalTasks = team.stats.numberOfTasksTotal;
        final completedTasks = team.stats.numberOfTasksCompleted;
        double progress = totalTasks > 0 ? completedTasks / totalTasks : 0;

        return  ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(team.meta.coverImage),
              backgroundColor: Colors.grey[200],
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    team.meta.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isPublic ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            subtitle: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(seconds: 1),
              builder: (context, value, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: value,
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.orangeAccent,
                      minHeight: 8,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$completedTasks / $totalTasks Tasks Completed',
                      style: PoppinsNorml(14, ColorsApp.textColorBlack)
                    ),
                  ],
                );
              },
            ),
            trailing: Images(teams, index),

        );
      },
    );
  }
}