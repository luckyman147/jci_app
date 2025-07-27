
import 'package:jci_app/features/Teams/data/models/CommentsModel.dart';
import 'package:jci_app/features/Teams/domain/entities/task/Comment.dart';
import 'package:jci_app/features/Teams/domain/entities/TaskFile.dart';

import '../../../data/models/CheckListModel.dart';
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
  //to json with only name and id

}


//make to json


//make from json


