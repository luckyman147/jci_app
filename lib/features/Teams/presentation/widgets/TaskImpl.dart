import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/util/snackbar_message.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import 'package:jci_app/features/Teams/presentation/screens/DetailsTaskScreen.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TaskDetailWidget.dart';

import 'package:jci_app/features/Teams/presentation/widgets/TaskWidget.dart';

import '../../../../core/widgets/loading_widget.dart';
import '../../../Home/presentation/widgets/ErrorDisplayMessage.dart';
import '../../domain/entities/Team.dart';
import '../../domain/usecases/TaskUseCase.dart';
import '../bloc/TaskFilter/taskfilter_bloc.dart';
import 'funct.dart';


Widget GetTasksWidget(Team team, MediaQueryData mediaQuery,
    TextEditingController controller) {
  return BlocBuilder<TaskfilterBloc, TaskfilterState>(
    builder: (context, st) {
      return BlocBuilder<GetTaskBloc, GetTaskState>(
          builder: (context, state) {
            if (state is AddTaskMessage) {
              context.read<TaskfilterBloc>().add(filterTask(state.tasks));

              return TaskWidget(tasks: state.tasks, team: team,);
            }

            switch (state.status) {
              case TaskStatus.initial:
                return LoadingWidget();
              case TaskStatus.error:
                return MessageDisplayWidget(message: state.errorMessage);
              case TaskStatus.success:
              case TaskStatus.Changed:
                if (st.selectedFilter==TaskFilter.All) {
                  return TaskWidget(tasks: state.tasks, team: team,);
                }
else if (st.selectedFilter==TaskFilter.Completed) {
                  return TaskWidget(tasks: TeamFunction.filterCompletedTasks(state.tasks), team: team,);
                }
                else  {
                  return TaskWidget(tasks:TeamFunction.filterPendingTasks(state.tasks), team: team,);
                }

              default:
                return LoadingWidget();
            }
          });
    },
  );
}

Widget GetTaskByidWidget(Team team, String taskId,
    TextEditingController TaskName, int index) {
  return BlocBuilder<GetTaskBloc, GetTaskState>(
    builder: (context, state) {
      if (state is GetTaskInitial || state is GetTaskLoading ||
          state.status == TaskStatus.Loading) {
        return LoadingWidget();
      } else if (state is GetTaskByIdLoaded) {
        return RefreshIndicator(
          onRefresh: () async {
            final inputFields input=inputFields(taskid: taskId, teamid: team.id, file: null, memberid: null, status: false, Deadline: null, StartDate: null, name: null, task: null, isCompleted: null, member: null, fileid: null, );

            context.read<GetTaskBloc>().add(
                GetTaskById(ids: input));
          },

          child: TaskDetailsWidget(
            task: state.tasks[index], index: index, team: team,),
        );
      } else if (state is GetTaskError) {
        return MessageDisplayWidget(message: "Error");
      }
      return MessageDisplayWidget(message: "Error");
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
                context.read<TaskVisibleBloc>().add(ToggleTaskVisible(false));
              },
              child: Container(
                  decoration: taskDecoration,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      children: [
                        Icon(Icons.add, color: PrimaryColor, size: 30,),


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

Widget TaskAddField(TextEditingController controller, String id) =>
    BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
      builder: (context, state) {
        return Padding(
          padding: paddingSemetricVerticalHorizontal(h: 18),
          child: InkWell(
            onTap: () {
              if (state.WillDeleted == false) {
                context.read<TaskVisibleBloc>().add(ToggleTaskVisible(false));
              }
            },
            child: Container(
              decoration: taskDecoration,
              child: TextField(

                controller: controller,

                style: PoppinsRegular(18, textColorBlack),
                onChanged: (value) {

                },
                decoration: InputDecoration(


                  enabled: state.WillAdded,

                  prefixIcon: GestureDetector(
                      onTap: () {
                        context.read<TaskVisibleBloc>().add(
                            ToggleTaskVisible(true));
                      },
                      child: state.WillAdded ? Icon(
                        Icons.cancel, color: Colors.red,) : SizedBox()
                  ),
                  suffixIcon: GestureDetector(
                      onTap: () {
                        if (controller.text.isEmpty) {
                          SnackBarMessage.showErrorSnackBar(
                              message: "Empty Field", context: context);
                        }
                        else {
                          final inputFields input=inputFields(taskid: '', teamid: id, file: null, memberid: null, status: false, Deadline: null, StartDate: null, name: controller.text, task: null, isCompleted: null, member: null, fileid: null, );

                          context.read<GetTaskBloc>().add(CreateTask(
                        input
                          ));

                          controller.clear();
                          context.read<TaskVisibleBloc>().add(
                              ToggleTaskVisible(true));
                          context.read<TaskVisibleBloc>().add(
                              ChangeIsUpdatedEvent(true));
                        }
                      },
                      child: state.WillAdded ? Icon(
                        Icons.check_circle, color: PrimaryColor,) : SizedBox()
                  ),
                  hintText: 'Add Task',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(18),
                ),
              ),

            ),
          ),
        );
      },
    );