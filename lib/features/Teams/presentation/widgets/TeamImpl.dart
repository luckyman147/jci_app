import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/widgets/loading_widget.dart';
import 'package:jci_app/features/Home/presentation/widgets/ErrorDisplayMessage.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import 'package:jci_app/features/Teams/presentation/widgets/DetailTeamWidget.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TeamWidget.dart';

import '../bloc/NumPages/num_pages_bloc.dart';

Widget allTeams(String id,ScrollController scrollController) {
  return BlocBuilder<NumPagesBloc, NumPagesState>(
    builder: (context, ste) {
      return BlocBuilder<GetTeamsBloc, GetTeamsState>(
          builder: (context, state) {


            switch (state.status){
              case TeamStatus.error:
                return MessageDisplayWidget(message: "Error");
                case TeamStatus.success:
                  if (state.teams.isEmpty) {
                    return MessageDisplayWidget(message: "No Data Found");
                  }
                  return RefreshIndicator(onRefresh: () {
                    context.read<GetTeamsBloc>().add(GetTeams());
                    return Future.value(true);
                  },
                  child: TeamWidget(teams: state.teams,scrollController: scrollController,hasReachedMax: state.hasReachedMax,));
case TeamStatus.initial:
                return LoadingWidget();
              default:
                return MessageDisplayWidget(message: "ErrorRRRRRRRRR");
            }

        //    if (state is GetTeamsInitial || state is GetTeamsLoading) {
          //    return LoadingWidget();
            //} else if (state is GetTeamsLoaded) {
            /*return RefreshIndicator(
            onRefresh: () async {
         //   context.read<GetTeamsBloc>().add(GetTeams());
            },
            child: TeamWidget(teams: state.teams,scrollController: scrollController));}

*/

          });
    },
  );
}

Widget GetTeamByid(String id,TextEditingController taskController) {
  return BlocBuilder<GetTeamsBloc, GetTeamsState>(
    builder: (context, state) {
      if (state is GetTeamsInitial || state is GetTeamsLoading) {
        return LoadingWidget();
      }   else if (state is GetTeamsLoadedByid) {
              log("zeeshan" + state.team.toString());
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<GetTeamsBloc>().add(GetTeamById(id));
                },
                child: TeamDetailWidget(team: state.team, taskController: taskController,),
              );
            }else if (state is GetTeamsError) {
        return MessageDisplayWidget(message: "Error");
      }
      return MessageDisplayWidget(message: "Error");
    },
  );
}