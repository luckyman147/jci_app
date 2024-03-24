import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import 'package:jci_app/features/Teams/presentation/widgets/DetailTeamWidget.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TeamImpl.dart';

import '../../../../core/strings/app_strings.dart';

class TeamDetailsScreen extends StatefulWidget {
  final String id;
  const TeamDetailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<TeamDetailsScreen> createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {
final TextEditingController _taskController = TextEditingController();
  @override
  void initState() {
    context.read<GetTeamsBloc>().add(GetTeamById(widget.id));
    context.read<GetTaskBloc>().add(GetTasks( id: widget.id));





    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(


body: SafeArea(child: Scrollbar(

  child: SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: Column(

      children: [

        SizedBox(
  height: mediaQuery.size.height,

            child: GetTeamByid(widget.id,  _taskController,)),
      ],
    ),
  ),
)),
    );
  }
}
