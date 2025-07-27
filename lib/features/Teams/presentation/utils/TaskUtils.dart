import 'package:auto_route/auto_route.dart';

import '../../../../core/route/app_router.dart';
import '../../../Home/Activity_Global.dart';
import '../../../Home/domain/enums/Privacy.dart';
import '../../domain/entities/task/Task.dart';
import '../bloc/GetTasks/get_task_bloc.dart';
import '../bloc/TaskFilter/taskfilter_bloc.dart';

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