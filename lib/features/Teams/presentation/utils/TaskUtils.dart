import 'package:auto_route/auto_route.dart';
import 'package:jci_app/features/MemberSection/domain/entity/Objectif.dart';
import 'package:jci_app/features/Teams/domain/dto/TaskIdParams.dart';

import '../../../../core/route/app_router.dart';
import '../../../Home/Activity_Global.dart';
import '../../../Home/domain/enums/Privacy.dart';
import '../../domain/entities/task/Task.dart';
import '../bloc/GetTasks/get_task_bloc.dart';
import '../bloc/TaskFilter/taskfilter_bloc.dart';
import '../constants/TeamConstants.dart';

class TaskUtils{
  static List<Map<String, dynamic>> filterCompletedTasks(
      List<Map<String, dynamic>> tasks) {
    List<Map<String, dynamic>> completedTasks = [];

    for (var task in tasks) {
      if (task['isCompleted'] == true) {
        completedTasks.add(task);
      }
    }

    return completedTasks;
  }
 static  List<PopupMenuItem<TaskCompletionStatus>> getLowerStatusMenuItems(
      TaskCompletionStatus currentStatus,BuildContext context,String teamId,Tasks task) {
    final allStatuses = TaskCompletionStatus.values;
    final currentIndex = currentStatus.index;

    return allStatuses
        .where((status) => status.index < currentIndex)
        .map((status) => PopupMenuItem<TaskCompletionStatus>(
      value: status,
      onTap: (){
        ChangeStatusTask(teamId, status, task, context);


      },
      child: Text(status.name.doublesWords,style: PoppinsRegular(14, TeamConstants.taskStatusColors[status]!),),
    ))
        .toList();
  }
  static List<PopupMenuItem<String>> buildTaskOptionsMenu({
    required VoidCallback onDelete,
    required VoidCallback onEdit,
    required BuildContext context,
  }) {
    return [
      PopupMenuItem<String>(
        value: 'delete',
        onTap: onDelete,
        child: buildContaineraction(Colors.red,"Delete".tr(context),Icons.delete),

    ),
      PopupMenuItem<String>(
        value: 'edit',
        onTap: onEdit,
        child: buildContaineraction(ColorsApp.PrimaryColor,"Edit".tr(context),Icons.edit),
      ),
    ];
  }

  static Container buildContaineraction(Color color ,String text,IconData icon) {
    return Container(
        decoration: BoxDecoration(
          color:  color.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(text, style: PoppinsRegular(16, color)),
          ],
        ),
      );
  }

  static TaskCompletionStatus? getNextStatus(TaskCompletionStatus currentStatus) {
  final allStatuses = TaskCompletionStatus.values;
  final currentIndex = currentStatus.index;

  if (currentIndex + 1 < allStatuses.length) {
    return allStatuses[currentIndex + 1];
  }
  return null; // already at last status
}


 static  void DeleteTaskFunction(BuildContext context,Tasks task,String teamId,{bool isAnotherpage=false}) {

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title:  Text("Want To delete this task?", style: PoppinsRegular(16, ColorsApp.textColorBlack) ,),
        content: Text(task.meta.id=='id' || task.meta .id.isEmpty
            ? "No ID found. What would you like to do?"
            : "Are you sure you want to proceed?"
       , style: PoppinsLight(14, ColorsApp.ThirdColor)
        ),
        actions: [
          TextButton(
            onPressed: () {
              final delete=AddTaskParams(task.meta.id, teamId: teamId, name: task.meta.name, status: task.meta.status);
              context.read<GetTaskBloc>().add(DeleteTask(delete));

              Navigator.pop(context);
              if(isAnotherpage){
              Navigator.pop(context);
           }

            },
            child:  Text("Confirm" ,style: PoppinsRegular(16, ColorsApp.PrimaryColor) ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: PoppinsRegular(16, ColorsApp.ThirdColor))
          ),
          if (task.meta.id == null)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Example third action
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Third action triggered")),
                );
              },
              child: const Text("Extra"),
            ),
        ],
      ),
    );
  }
  static Map<TaskCompletionStatus, String> getTaskStatusTitles(BuildContext context, {String locale = 'en'}) {
    switch (locale) {
      case 'fr':
        return {
          TaskCompletionStatus.Todo: 'À faire',
          TaskCompletionStatus.InProgress: 'En cours',
          TaskCompletionStatus.Completed: 'Terminées',
          TaskCompletionStatus.Delayed: 'En retard',
        };
      default:
        return {
          TaskCompletionStatus.Todo: 'To Do',
          TaskCompletionStatus.InProgress: 'In Progress',
          TaskCompletionStatus.Completed: 'Completed',
          TaskCompletionStatus.Delayed: 'Delayed',
        };
    }
  }
 static TaskCompletionStatus? getPreviousStatus(TaskCompletionStatus currentStatus) {
    final allStatuses = TaskCompletionStatus.values;
    final currentIndex = currentStatus.index;

    if (currentIndex - 1 >= 0) {
      return allStatuses[currentIndex - 1];
    }
    return null; // already at the first status
  }

  static List<PopupMenuItem<TaskCompletionStatus>> getHigherStatusMenuItems(String teamId,
      TaskCompletionStatus currentStatus,Tasks task,BuildContext context) {
    final allStatuses = TaskCompletionStatus.values;
    final currentIndex = currentStatus.index;

    return allStatuses
        .where((status) => status.index > currentIndex)
        .map((status) => PopupMenuItem<TaskCompletionStatus>(
      onTap:  () {
        ChangeStatusTask(teamId, status, task, context);

      },
      value: status,
      child:Row(
        children: [
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color:  TeamConstants.taskStatusColors[status]!,
              shape: BoxShape.circle,
            ),
          ),
        Text(status.name.doublesWords,style: PoppinsRegular(14, TeamConstants.taskStatusColors[status]!)),

        ]
    )))
        .toList();
  }

  static void ChangeStatusTask(String teamId, TaskCompletionStatus status, Tasks task, BuildContext context) {
           final updateStat=UpdateTaskParams.fromStatus(teamId,status, task);
    context.read<GetTaskBloc>().add(UpdateStatus( updateStat));
  }


  static void ReturnFunbction(BuildContext context, TaskVisibleState ste) {
    context.navigateTo(HomeRoute());

    context.read<GetTaskBloc>().add(resetevent());

    context
        .read<TaskVisibleBloc>()
        .add(const changePrivacyEvent(Privacy.Primary));
    // context
    //   .read<GetTeamsBloc>()
    // .add(GetTeams( null,ste.isUpdated,isPrivate: false));
    context.read<TaskVisibleBloc>().add(ChangeIsUpdatedEvent(ste.isUpdated));

    context.read<TaskfilterBloc>().add(const filterTask([]));
  }

  static Tasks findTaskById(
      List<Tasks> tasks, String id) {
    final task = tasks.firstWhere((task) => task.meta.id == id,
        orElse: () => throw Exception('Task with id $id not found'));
    return task;
  }

  static List<Map<String, dynamic>> filterPendingTasks(
      List<Map<String, dynamic>> tasks) {
    return tasks.where((task) => task['isCompleted'] == false).toList();
  }
  static int getIndexById(String id, List<Map<String, dynamic>> list) {
    for (int i = 0; i < list.length; i++) {
      if (list[i]['id'] == id) {
        return i;
      }
    }
    // If the id is not found in any map, return -1
    return -1;
  }
}