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
import '../bloc/TaskActions/task_actions_bloc.dart';

Widget GetTasksWidget(String id, MediaQueryData mediaQuery,
    TextEditingController controller) {
  return BlocBuilder<GetTaskBloc, GetTaskState>(
      builder: (context, state) {
        log(state.status.toString());
        if (state is AddTaskMessage) {
          log("AddTaskMessage");
          return TaskWidget(tasks: state.tasks, teamid: id,);

        }

        switch(state.status){
          case TaskStatus.initial:
            return LoadingWidget();
          case TaskStatus.error:
            return MessageDisplayWidget(message: state.errorMessage);
          case TaskStatus.success:
            return TaskWidget(tasks: state.tasks, teamid: id,);
            case TaskStatus.Changed:
              log(state.tasks.length.toString());
              return TaskWidget(tasks: state.tasks, teamid: id,);
          default:
            return LoadingWidget();
        }

      });
}
Widget GetTaskByidWidget(String id,String taskId,TextEditingController TaskName,){
  return BlocBuilder<GetTaskBloc, GetTaskState>(
    builder: (context, state) {
      if (state is GetTaskInitial || state is GetTaskLoading) {
        return LoadingWidget();
      }   else if (state is GetTaskByIdLoaded) {
        log("zeeshan" + state.task.toString());
        return RefreshIndicator(
          onRefresh: () async {
            context.read<GetTaskBloc>().add(GetTaskById(ids:{'id': id, 'taskid': taskId}));
          },

          child: TaskDetailsWidget(task: state.task, TaskNamed:TaskName , ),
        );
      }else if (state is GetTaskError) {
        return MessageDisplayWidget(message: "Error");
      }
      return MessageDisplayWidget(message: "Error");
    },
  );
}

Widget AddTask(mediaQuery,) =>
    BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
      builder: (context, state) {
        log("${!state.WillAdded}");
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
              context.read<TaskVisibleBloc>().add(ToggleTaskVisible(false));
            },
            child: Container(
              decoration: taskDecoration,
              child: TextField(

                controller: controller,
                onTapOutside: (rr) {
                  context.read<TaskVisibleBloc>().add(ToggleTaskVisible(true));
                },
                style: PoppinsRegular(18, textColorBlack),
                onChanged: (value) {
                  log(controller.text);
                },
                decoration: InputDecoration(


                  enabled: state.WillAdded,

                  prefixIcon: GestureDetector(
                      onTap: () {
                        context.read<TaskVisibleBloc>().add(
                            ToggleTaskVisible(true));
                      },
                      child: state.WillAdded ? Icon(Icons.cancel,color: Colors.red,) : SizedBox()
                  ),
                  suffixIcon: GestureDetector(
                      onTap: () {
                        if (controller.text.isEmpty) {
                          SnackBarMessage.showErrorSnackBar(
                              message: "Empty Field", context: context);
                        }
                        else {
                          log(id);
                          context.read<GetTaskBloc>().add(CreateTask({
                            "Teamid": id,
                            "name": controller.text
                          }));
                          controller.clear();
                          context.read<TaskVisibleBloc>().add(
                              ToggleTaskVisible(true));
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