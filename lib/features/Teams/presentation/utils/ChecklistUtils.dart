import '../../domain/entities/Checklist.dart';
import '../../domain/entities/task/Task.dart';
import '../../domain/entities/TaskFile.dart';

class CheckListUtils {

  static List<Map<String, dynamic>> deleteChecklist(
      List<Map<String, dynamic>> tasks, int taskId, int checklistId) {
    return tasks.map((task) {
      if (task['id'] == taskId) {
        task['CheckLists'] = (task['CheckLists'] as List)
            .where((checklist) => checklist['id'] != checklistId)
            .toList();
      }
      return task;
    }).toList();
  }
}