import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';
import '../../../../domain/entities/Team/Team.dart';
import '../../../../domain/entities/task/Task.dart';
import '../../common/TasKInputField.dart';
import '../../common/TaskHeader.dart';
import 'TaskTile.dart';


class TaskColumn extends StatelessWidget {
  final String title;
  final TaskCompletionStatus status;
  final Color color;
  final Team team;

  final String teamId;
  final List<Tasks> tasks;

  const TaskColumn({

    super.key,
    required this.teamId,

    required this.team,
    required this.title,
    required this.status,
    required this.color,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,

      child:
      IntrinsicHeight(
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color, width: 2),
          borderRadius: BorderRadius.circular(19),
        ),
        margin: const EdgeInsets.all(18),

        color: ColorsApp.textColorWhite,
        child:
        Padding(padding: paddingSemetricVerticalHorizontal(), child: Column(
          children: [
       Padding(padding: paddingSemetricVerticalHorizontal(),child:TaskHeader(title: title, color: color,numTasks: tasks.length,), ),

            TaskInputField(status: status, teamId: teamId,color: color,),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) => TaskTile(task: tasks[index], team: team,),
              ),
            ),
          ],
        ),
      ),
    )));
  }
  double _calculateTaskListHeight(int taskCount) {
    const double baseHeightPerTask = 75.0;
    const double maxListHeight = 400.0;
    return (taskCount * baseHeightPerTask).clamp(75.0, maxListHeight);
  }

}
