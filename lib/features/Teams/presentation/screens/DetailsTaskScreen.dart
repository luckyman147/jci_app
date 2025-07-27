import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/Teams/domain/usecases/TaskUseCase.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';

import 'package:jci_app/features/Teams/presentation/widgets/Task/Implementation/TaskImpl.dart';


import '../../../Home/domain/enums/Privacy.dart';
import '../../domain/entities/Team/Team.dart';
import '../utils/TaskUtils.dart';
@RoutePage()
class CreateTaskScreen extends StatefulWidget {
  final Team team;
  final String taskId;


  const CreateTaskScreen({Key? key, required this.team, required this.taskId})
      : super(key: key);

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

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
    final mediaQuery = MediaQuery.of(context);

    return  BlocBuilder<GetTaskBloc, GetTaskState>(
        builder: (context, state) {
   /*       return SingleChildScrollView(
            child: GetTaskByidWidget(
                widget.team, widget.taskId, _taskNameController,
                TaskUtils.  getIndexById(widget.taskId, state.tasks)),
          );

     */
          return SizedBox();
        },
      
    );
  }
}
