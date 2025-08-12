

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/util/snackbar_message.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import 'package:jci_app/features/Teams/presentation/utils/TaskUtils.dart';

import 'package:jci_app/features/Teams/presentation/widgets/Task/details/TaskDetailWidget.dart';

import 'package:jci_app/features/Teams/presentation/widgets/Task/details/TaskWidget.dart';

import '../../../../../../core/widgets/loading_widget.dart';
import '../../../../domain/entities/Team/Team.dart';
import '../../../../domain/entities/task/Task.dart';
import '../../../../domain/usecases/TaskUseCase.dart';
import '../../../bloc/TaskFilter/taskfilter_bloc.dart';
import '../../../Loadings/ShimmerEffects.dart';



Widget GetTasksWidget(Team team, MediaQueryData mediaQuery,
    TextEditingController controller) {
  return BlocBuilder<TaskfilterBloc, TaskfilterState>(
    builder: (context, st) {
      return BlocBuilder<GetTaskBloc, GetTaskState>(
          builder: (context, state) {


            switch (state.status) {
              case TaskStatus.initial:

              case TaskStatus.error:
              context.read<GetTaskBloc>().add(GetTasks(id:team.meta.id,filter: TaskCompletionStatus.Todo));

              return const TaskShimmer();
              case TaskStatus.success:
              case TaskStatus.Changed:
              case TaskStatus.ErrorUpdate:

                  return    TaskStatusBoard(tasks: state.tasks, teamId: team.meta.id,
                    team: team,
                    isVertical: context.watch<TaskVisibleBloc>().state.isColumn,);


              default:
                return  const TaskShimmer();
            }
          });
    },
  );
}

Widget GetTaskByidWidget(Team team ,
    TextEditingController TaskName,Tasks task) {
  return BlocBuilder<GetTaskBloc, GetTaskState>(
    builder: (context, state) {

      switch (state.status) {
        case TaskStatus.initial:

        case TaskStatus.error:
          return const LoadingWidget();
        case TaskStatus.success:
        case TaskStatus.Changed:
        case TaskStatus.ErrorUpdate:

          return  TaskDetailsWidget(
          task: state.task!,  team: team,);



        default:
          return  const LoadingWidget();
      }
    },
  );
}



Widget AddTask(mediaQuery,) =>
    BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
      builder: (context, state) {
        return Padding(
          padding: paddingSemetricVerticalHorizontal(h: 18),
          child: Visibility(
            visible: !state.WillAdded,
            child: InkWell(
              onTap: () {
                context.read<TaskVisibleBloc>().add(const ToggleTaskVisible(false));
              },
              child: Container(
                  decoration: taskDecoration,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      children: [
                 const       Icon(Icons.add, color: PrimaryColor, size: 30,),


                        Text('Add Task', style: PoppinsSemiBold(
                            mediaQuery.devicePixelRatio * 4, textColorBlack,
                            TextDecoration.none))
                      ],
                    ),
                  )

              ),
            ),
          ),
        );
      },
    );

