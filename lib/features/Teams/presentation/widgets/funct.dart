import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/Teams/domain/entities/Checklist.dart';
import 'package:jci_app/features/Teams/domain/entities/Task.dart';
import 'package:jci_app/features/auth/domain/entities/Member.dart';

import '../../../Home/presentation/bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../../../auth/presentation/bloc/Members/members_bloc.dart';

bool doesObjectExistInList(List<Object> list, Object targetObject) {
  return list.contains(targetObject);
}
List<String> getIds(List<Member> objects) {
  if (objects.isEmpty || objects == null  ) {
    return [];
  }
  return objects.map((obj) => obj.id ).toList();
}
List<int> generateNumbers(int num) {
  return List.generate(num, (index) => num - index + 1).reversed.toList();
}
List<Map<String, dynamic>> mapObjects(List<Tasks> objects) {
  return objects.map((object) => {'id': object.id, 'isCompleted': object.isCompleted}).toList();
}List<Map<String, dynamic>> mapChecklist(List<CheckList> objects) {
  return objects.map((object) => {'id': object.id, 'isCompleted': object.isCompleted,"name":object.name,"IsUpdated":false}).toList();
}
int getIndexById(String id, List<Map<String, dynamic>> list) {
  for (int i = 0; i < list.length; i++) {
    if (list[i]['id'] == id) {
      return i;
    }
  }
  // If the id is not found in any map, return -1
  return -1;
}

Map<String, dynamic> toMap(Tasks object) {
  return {'id': object.id, 'isCompleted': object.isCompleted, 'name': object.name,"willDeleted":false, "WillUpdated":false,
    'description': object.description, 'StartDate': object.StartDate, 'Deadline': object.Deadline, 'AssignTo': object.AssignTo,
    'attachedFile': object.attachedFile, 'CheckLists': object.CheckLists.map((e) => toMapChecklist(e)),};
}
Map<String, dynamic> toMapChecklist(CheckList object) {
  return {'id': object.id, 'isCompleted': object.isCompleted, 'name': object.name,};
}
Map<String, dynamic> toMapMember(Member object) {
  return {'id': object.id, 'firstName': object.firstName, 'Images': object.Images,};
}
List<Map<String, dynamic>> convertIdKey(List<dynamic> inputList) {
  List<Map<String, dynamic>> resultList = [];

  for (var item in inputList) {
    if (item is Map<String, dynamic>) {
      if (item.containsKey('_id')) {
        var idValue = item['_id'];
        item.remove('_id');
        item['id'] = idValue;
      }
      resultList.add(item);
    } else {
      // Handle if item is not a Map<String, dynamic>
      // You may choose to skip, log, or handle these cases differently
      // For this example, we skip them
      continue;
    }
  }

  return resultList;
}

Map<String, dynamic> findTaskById(List<Map<String, dynamic>> tasks, String id) {
  final task = tasks.firstWhere((task) => task['id'] == id, orElse: () => throw Exception('Task with id $id not found'));
  return task;
}
bool allCompleted(List<Map<String, dynamic>> maps) {
  return maps.every((map) => map['isCompleted'] ?? false);
}
bool noneCompleted(List<Map<String, dynamic>> maps) {
  return !maps.any((map) => map['isCompleted'] ?? false);
}

List<Map<String, dynamic>> deleteChecklist(List<Map<String, dynamic>> tasks, int taskId, int checklistId) {
  final updatedTasks = [...tasks.map((task) {
    if (task['id'] == taskId) {
      // Remove the checklist with the matching ID
      task['CheckLists'] = UnmodifiableListView(task['CheckLists'].where((checklist) => checklist['id'] != checklistId).toList());
    }
    return task;
  })];

  return updatedTasks;
}
List<Map<String, dynamic>> updateTask(List<Map<String, dynamic>> tasks, Map<String, dynamic> updatedTask) {
  int index = tasks.indexWhere((task) => task['id'] == updatedTask['id']);

  if (index == -1) {
    throw Exception('Task not found');
  }

  tasks[index] = updatedTask;

  return tasks;
}

Future<void> DatePickerFun(BuildContext context,DateTime time,Function(DateTime) OnsubmitDate) async {
  final temp = await showDatePicker(
    context: context,

    firstDate: DateTime(DateTime.now().year, DateTime.now().month,),
    currentDate: time,
    lastDate: DateTime.now().add(Duration(days: 365)),

  );

  if (temp != null) {
    OnsubmitDate(temp);

  }
}
void SearchAction(BuildContext context, String value, FormzState state) {
  context.read<FormzBloc>().add(MembernameChanged( name: value));
  if (state.memberName.value.length > 1){
    context.read<MembersBloc>().add(GetMemberByNameEvent( name: state.memberName.value));}
  else if (state.memberName.value.isEmpty|| state.memberName.displayError!= null ){
    context.read<MembersBloc>().add(GetAllMembersEvent());
  }
}