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

Widget allTeams(String id) {
  return BlocBuilder<GetTeamsBloc, GetTeamsState>(
      builder: (context, state) {
    if (state is GetTeamsInitial || state is GetTeamsLoading) {
      return LoadingWidget();
    } else if (state is GetTeamsLoaded) {
      return RefreshIndicator(
        onRefresh: () async {
          context.read<GetTeamsBloc>().add(GetTeams());
        },
        child: TeamWidget(teams: state.teams),
      );
    } else if (state is GetTeamsLoadedByid) {
      log("zeeshan" + state.team.toString());
      return RefreshIndicator(
        onRefresh: () async {
          context.read<GetTeamsBloc>().add(GetTeamById(id));

        },
        child: TeamDetailWidget(team: state.team),
      );
    } else if (state is GetTeamsError) {
      return MessageDisplayWidget(message: state.message);
    }
    return Container();
      });}

