import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jci_app/features/Home/Activity_Global.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';

import '../../../../../../core/PrimitiveUser/User.dart';
import '../../../../../../core/app_theme.dart';
import '../../../../../../core/route/app_router.dart';
import '../../../../domain/entities/TeamUser.dart';
import '../../../../domain/usecases/TeamUseCases.dart';
import 'AnimatedCheckMark.dart';
import 'JoinTeamDialogContent.dart';

class JoinTeamDialog extends StatelessWidget {
  final String teamName,TeamId;
  final TeamUser user;
  final bool requiresPin;
  final Function() onJoin;


  const JoinTeamDialog({
    Key? key,
    required this.user,
    required this.TeamId,
    required this.teamName,
    required this.requiresPin,
    required this.onJoin,

  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextEditingController pinController = TextEditingController();

    return AlertDialog(
      contentPadding: EdgeInsets.zero, // Optional: remove default padding
      content: SizedBox(
        height: 200, // 🔥 Set desired height here
        width: MediaQuery.of(context).size.width * 0.8, // Optional width control
        child: BlocConsumer<GetTeamsBloc, GetTeamsState>(
          listener: (context, state) {
            if (state.status == TeamStatus.Created) {
              Future.delayed(const Duration(seconds: 2), () {
                onJoin();
                Navigator.pop(context);
              });
            }
          },
          builder: (context, state) {
            if (state.status == TeamStatus.LoadingJoin) {
              return const LoadingWidget();
            } else if (state.status == TeamStatus.Created) {
              return  AnimatedCheckAvatar ();
            }

            return JoinTeamDialogContent(
              status: requiresPin,
              onJoin: (pincode) {
                context.read<GetTeamsBloc>().add(
                  JoinTeam(
                    inputs: TeamInput(TeamId, "", "", user),
                  ),
                );
              },
            );
          },
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
