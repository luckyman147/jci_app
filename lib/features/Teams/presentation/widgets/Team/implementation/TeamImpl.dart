

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/widgets/loading_widget.dart';
import 'package:jci_app/features/Teams/data/models/TeamModel.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import 'package:jci_app/features/Teams/presentation/widgets/Team/Detail/DetailTeamWidget.dart';
import 'package:jci_app/features/Teams/presentation/widgets/Team/%20component/TeamWidget.dart';

import '../../../bloc/NumPages/num_pages_bloc.dart';
import '../../../Loadings/ShimmerEffects.dart';
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
                  return const ShimmerListView(itemCount: 3,);
                case TeamStatus.success:
                case TeamStatus.LoadedTeams:
                case TeamStatus.LoadedTeam:
                case TeamStatus.LoadingJoin:
                case TeamStatus.Created:


                  if (state.teams.isEmpty) {
                    return const ShimmerListView(itemCount: 3);
                  }
                  return RefreshIndicator(onRefresh: () {
                    context.read<GetTeamsBloc>().add(GetTeams(null,true,isPrivate: isHome?true:false ));
                    return Future.value(true);
                  },
                      child:


                      TeamWidget(isPrivate: isHome?true:false,state: state,teams: state.teams,scrollController: scrollController,hasReachedMax: state.teams.length<=3?true: state.hasReachedMax,));
                case TeamStatus.initial:
                case TeamStatus.IsRefresh:
                  return const ShimmerListView(itemCount: 3); {}
                default:
                  return const ShimmerListView(itemCount: 3);}

            }, listener: (BuildContext context, GetTeamsState state) {


          },);
        },
      );
    },
  );
}


Widget GetTeamByid(String id, TextEditingController taskController, int index) {
  return BlocBuilder<GetTeamsBloc, GetTeamsState>(
    builder: (context, state) {
      switch (state.status) {
        case TeamStatus.initial:
        case TeamStatus.Loading:
          return const ShimmerLoadingScreen();

        case TeamStatus.success:
        case TeamStatus.Updated:
        case TeamStatus.LoadedTeam:

        case TeamStatus.LoadedTeams:

        case TeamStatus.IsRefresh:
        case TeamStatus.Created:
          return RefreshIndicator(
            onRefresh: () async {
              context.read<GetTeamsBloc>().add(
                GetTeamById({"id": id, "isUpdated": true}),
              );
            },
            child: state.teamById != null
                ? TeamDetailWidget(
              team: state.teamById!,
              taskController: taskController,
            )
                : Center(child: LoadingWidget()),
          );

        case TeamStatus.error:
          context.read<GetTeamsBloc>().add(GetTeamById({"id": id, "isUpdated": true}));
          return const ShimmerLoadingScreen();

        default:
          return const ShimmerLoadingScreen();
      }
    },
  );
}

