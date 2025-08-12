import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/Teams/domain/usecases/TaskUseCase.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';

import 'package:jci_app/features/Teams/presentation/widgets/Task/Implementation/TaskImpl.dart';


import '../../../Home/domain/enums/Privacy.dart';
import '../../domain/entities/Team/Team.dart';
import '../../domain/entities/task/Task.dart';
import '../utils/TaskUtils.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String teamId;
  final Team  team;
  final Tasks task;


  const TaskDetailsScreen({Key? key, required this.team, required this.task, required this.teamId})
      : super(key: key);
  static void openTaskDetailsBottomSheet(BuildContext context, Team team, Tasks task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return
        SizedBox(
              height: MediaQuery.of(context).size.height*2
        ,
         child:
         SingleChildScrollView(

              child: TaskDetailsScreen(team: team, task: task, teamId: team.meta.id,),
         ));
          },


    );
  }
  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final TextEditingController _taskNameController = TextEditingController();


  @override
  void initState() {


    context.read<TaskVisibleBloc>().add(const ToggleTaskVisible(true));
    context.read<TaskVisibleBloc>().add(const ChangeTextFieldsTitle(TextFieldsTitle.Inactive));

    //   context.read<MembersBloc>().add(GetAllMembersEvent());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return

      Scaffold(

      body:
      BlocBuilder<GetTaskBloc, GetTaskState>(
        builder: (context, state) {
        return SingleChildScrollView(
            child: GetTaskByidWidget(
                widget.team,  _taskNameController,widget.task
               ),
          );



        },
      
    ));
  }
}
