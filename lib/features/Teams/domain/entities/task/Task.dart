
import 'package:jci_app/features/Teams/data/models/CommentsModel.dart';
import 'package:jci_app/features/Teams/domain/entities/task/Comment.dart';
import 'package:jci_app/features/Teams/domain/entities/TaskFile.dart';

import '../../../data/models/CheckListModel.dart';
import '../../../data/models/TaskModel.dart';
import '../Checklist.dart';
import 'TaskCommunication.dart';
import 'TaskContent.dart';
import 'TaskMeta.dart';
enum TaskCompletionStatus {
  Todo,
  InProgress,
  Completed,
  Delayed,
}
class Tasks {
  final TaskMeta meta;
  final TaskContent content;
  final TaskCommunication communication;

  Tasks({
    required this.meta,
    required this.content,
    required this.communication,
  });
  Tasks copyWith({
    TaskMeta? meta,
    TaskContent? content,
    TaskCommunication? communication,
  }) {
    return Tasks(
      meta: meta ?? this.meta,
      content: content ?? this.content,
      communication: communication ?? this.communication,
    );
  }
  // to model
  TaskModel toModel() {
    return TaskModel(
      meta: meta,
      content: content,
      communication: communication,
    );
  }
  //to json with only name and id
factory Tasks.fromName(String name,TaskCompletionStatus status){
  return Tasks(
    meta: TaskMeta.empty(name,status),
    content: TaskContent.empty(),
    communication: TaskCommunication(
      comments: [],

    ),
  );
}
}


//make to json


//make from json


