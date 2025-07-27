import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/Home/Activity_Global.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';
import '../../../../domain/entities/task/Task.dart';

class TaskTile extends StatelessWidget {
  final Tasks task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: GestureDetector(
          onDoubleTap: () { context.read<TaskVisibleBloc>().add(ToggleTaskVisibleById(task.meta.id));},
          child: Text(task.name),
        ),
        onTap: () => context.read<GetTaskBloc>().add(NavigateToTaskDetails(task)),
        onLongPress: () => context.read<GetTaskBloc>().add(DeleteTask(task)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.read<GetTaskBloc>().add(MoveTaskToPreviousStatus(task)),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => context.read<GetTaskBloc>().add(MoveTaskToNextStatus(task)),
        ),
      ),
    );
  }
}
