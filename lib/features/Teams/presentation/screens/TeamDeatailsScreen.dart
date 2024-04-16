import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/services/TeamStore.dart';
import 'package:jci_app/core/util/snackbar_message.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskFilter/taskfilter_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import 'package:jci_app/features/Teams/presentation/widgets/DetailTeamWidget.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TeamImpl.dart';
import 'package:jci_app/features/Teams/presentation/widgets/funct.dart';

import '../../../../core/strings/app_strings.dart';

class TeamDetailsScreen extends StatefulWidget {
  final String id;
  final int index;

  const TeamDetailsScreen({Key? key, required this.id, required this.index}) : super(key: key);

  @override
  State<TeamDetailsScreen> createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {



TeamFunction.init(widget.id,context);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(


      body: SafeArea(child: BlocListener<GetTeamsBloc, GetTeamsState>(
        listener: (context, state) {
             TeamFunction. ListenerDelete(state, context,widget.id);

        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(

            children: [

              SizedBox(
                  height: mediaQuery.size.height,

                  child: GetTeamByid(widget.id, _taskController,widget.index)),
            ],
          ),
        ),
      )),
    );
  }


}
