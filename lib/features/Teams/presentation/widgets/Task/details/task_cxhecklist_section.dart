import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/task/Task.dart';
import '../../../../domain/entities/Team/Team.dart';
import '../../../bloc/GetTasks/get_task_bloc.dart';
import '../../../components/CheckList.dart';

import '../../../../../../core/app_theme.dart';

class TaskChecklistSection extends StatelessWidget {
  final Tasks task;
  final Team team;
  final FocusNode checklistFocus;
  final TextEditingController controller;
  final MediaQueryData mediaQuery;

  const TaskChecklistSection({
    super.key,
    required this.task,
    required this.team,
    required this.checklistFocus,
    required this.controller,
    required this.mediaQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: taskdex,
      child: Column(
        children: [
          Padding(
            padding: paddingSemetricVertical(),
            child: CheckListAddField(
              controller,
              task.meta.id,
              checklistFocus,
              mediaQuery,
              team.meta.id,
              true,
            ),
          ),
          BlocBuilder<GetTaskBloc, GetTaskState>(
            builder: (context, state) {
              final i = state.task!.content.checkLists.length;
              final height = i < 3 ? i * 100 : 277;

              return AnimatedContainer(
                height: height.toDouble(),
                duration: const Duration(milliseconds: 100),
                child: CheckListWidget(
                  checkList: task.content.checkLists,

                  tasks: state.task!,
                  teamId: team.meta.id,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
