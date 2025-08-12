import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';

import '../../domain/entities/Checklist.dart';
import '../../domain/entities/task/Task.dart';
import '../../domain/entities/TaskFile.dart';

class CheckListUtils {

  static List<CheckList> deleteChecklist(
      List<CheckList> checklists,  String checklistId) {
    return   checklists.where((checklist) => checklist.id != checklistId).toList();
  }

  static List<CheckList>updateChecklistStatus(List<CheckList> checkLists, String checkId, bool isCompleted) {
    return checkLists.map((checklist) {
      if (checklist.id == checkId) {
        return checklist.copyWith(isCompleted: isCompleted);
      }
      return checklist;
    }).toList();
  }

  static List<CheckList> updateChecklistName(List<CheckList> checkLists, String checkId, String name) {
    return checkLists.map((checklist) {
      if (checklist.id == checkId) {
        return checklist.copyWith(name: name);
      }
      return checklist;
    }).toList();
  }

  static List<CheckList> addChecklist(List<CheckList> checkLists,CheckList checklist) {

    Logger ().d('Adding checklist: ${checklist.name} with id: ${checklist.id}');
    // Check if the checklist already exists
    return [...checkLists, checklist];


  }
}