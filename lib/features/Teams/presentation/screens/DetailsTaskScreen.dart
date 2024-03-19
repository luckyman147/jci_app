import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TaskDetailWidget.dart';
import 'package:jci_app/features/Teams/presentation/widgets/CreateTeamWIdgets.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TaskImpl.dart';

import '../../../Home/presentation/widgets/AddActivityWidgets.dart';
import '../../../auth/presentation/bloc/Members/members_bloc.dart';

class CreateTaskScreen extends StatefulWidget {
  final String teamId;
  final String taskId;

  const CreateTaskScreen({Key? key, required this.teamId, required this.taskId})
      : super(key: key);

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    context.read<GetTaskBloc>().add(
        GetTaskById(ids: {"id": widget.teamId, "taskid": widget.taskId}));

 //   context.read<MembersBloc>().add(GetAllMembersEvent());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
     /* appBar: AppBar(
        backgroundColor: Colors.white,
        title: BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
          builder: (context, state) {
            return TaskDetailHeader(context, widget.teamId,widget.taskId, "Task Details",state.WillAdded);
          },
        ),
      ),*/


      body: SizedBox(
        height: mediaQuery.size.height,

        child: GetTaskByidWidget(widget.teamId, widget.taskId,_taskNameController,),)
    ,
    );
  }
}
