import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/app_theme.dart';
import '../../../../../Home/domain/enums/Privacy.dart';
import '../../../../domain/dto/TaskIdParams.dart';
import '../../../../domain/entities/task/Task.dart';
import '../../../bloc/GetTasks/get_task_bloc.dart';
import '../../../bloc/TaskIsVisible/task_visible_bloc.dart';
import 'TaskComponents.dart';

class TaskNameEditor extends StatelessWidget {
  final MediaQueryData mediaQuery;
  final Tasks task;
  final FocusNode taskNameFocusNode;
  final TextEditingController taskNameController;

  const TaskNameEditor({
    Key? key,
    required this.mediaQuery,
    required this.task,
    required this.taskNameFocusNode,
    required this.taskNameController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
      builder: (context, state) {
        return Padding(
          padding: paddingSemetricVertical(),
          child:
          Container(
            decoration: taskdex,
            child:
          Row(
            children: [
              _buildBackOrCancelButton(context, state),
              Expanded(
                child: _buildTextField(context, state),
              ),
            ],
          ),
          ),
        );
      },
    );
  }

  Widget _buildBackOrCancelButton(
      BuildContext context, TaskVisibleState state) {
    var bool = state.textFieldsTitle == TextFieldsTitle.Active;
    return IconButton(
      onPressed: () {
        if (state.textFieldsTitle == TextFieldsTitle.Active) {
          context
              .read<TaskVisibleBloc>()
              .add(const ChangeTextFieldsTitle(TextFieldsTitle.Inactive));
        } else {
          Navigator.pop(context);
        }
      },
      icon: Icon(
        bool
            ? Icons.cancel
            : Icons.arrow_back,
        color: bool? Colors. red:ColorsApp.ThirdColor,
        size: 20,
      ),
    );
  }

  Widget _buildTextField(BuildContext context, TaskVisibleState state,{int minlines=1}) {
    final isActive = state.textFieldsTitle == TextFieldsTitle.Active;

    return buildTextField(
   minlines   :minlines,
      taskNameFocusNode,
      isActive,
      taskNameController,
          () {
        context
            .read<TaskVisibleBloc>()
            .add(const ChangeTextFieldsTitle(TextFieldsTitle.Active));
        FocusScope.of(context).requestFocus(taskNameFocusNode);
      },
      "TaskName here",
      mediaQuery,
          () {
        final input =
        UpdateTaskParams.fromName(taskNameController.text, task);
        context.read<GetTaskBloc>().add(UpdateTaskNameEvent(input));
        context
            .read<TaskVisibleBloc>()
            .add(const ChangeTextFieldsTitle(TextFieldsTitle.Inactive));
        context
            .read<TaskVisibleBloc>()
            .add(const ChangeIsUpdatedEvent(true));
      },
    );
  }
}
