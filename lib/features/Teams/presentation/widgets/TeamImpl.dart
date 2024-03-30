import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/widgets/loading_widget.dart';
import 'package:jci_app/features/Home/presentation/widgets/ErrorDisplayMessage.dart';
import 'package:jci_app/features/Teams/data/models/TeamModel.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import 'package:jci_app/features/Teams/presentation/widgets/DetailTeamWidget.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TeamWidget.dart';

import '../bloc/NumPages/num_pages_bloc.dart';
enum TeamAction { Upload, delete,Exit }
Widget allTeams(String id,ScrollController scrollController,bool isHome) {
  return BlocBuilder<NumPagesBloc, NumPagesState>(
    builder: (context, ste) {
      return BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
  builder: (context, sta) {
    return BlocConsumer<GetTeamsBloc, GetTeamsState>(
          builder: (context, state) {


            switch (state.status){
              case TeamStatus.error:
                return MessageDisplayWidget(message: state.errorMessage);
                case TeamStatus.success:

                  if (state.teams.isEmpty) {
                    return MessageDisplayWidget(message: "No Data Found");
                  }
                  return RefreshIndicator(onRefresh: () {
                    context.read<GetTeamsBloc>().add(GetTeams(isPrivate: isHome?true:false ));
                    return Future.value(true);
                  },
                  child:
                  isHome?TeamHomeWidget(teams: state.teams):

                  TeamWidget(teams: state.teams,scrollController: scrollController,hasReachedMax: state.teams.length<=3?true: state.hasReachedMax,));
case TeamStatus.initial:

                return LoadingWidget();
              case TeamStatus.IsRefresh:
                return LoadingWidget();
              default:
                return Text("data");
            }

          }, listener: (BuildContext context, GetTeamsState state) {


    },);
  },
);
    },
  );
}


Widget GetTeamByid(String id,TextEditingController taskController,int index) {
  return BlocBuilder<GetTeamsBloc, GetTeamsState>(
    builder: (context, state) {
      if (state is GetTeamsInitial || state is GetTeamsLoading) {
        return LoadingWidget();
      }   else if (state.status ==TeamStatus.success ) {
              log("zeeshan" + state.teamById.toString());
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<GetTeamsBloc>().add(GetTeamById({"id": id,"isUpdated":false}));
                },

                child: TeamDetailWidget(team:TeamModel.fromJson( state.teamById), taskController: taskController,),
              );
            }else if (state.status ==TeamStatus.error ) {
        return MessageDisplayWidget(message: "Error");
      }
      return LoadingWidget();
    },
  );
}