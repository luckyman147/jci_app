import 'package:jci_app/features/Teams/domain/entities/task/Task.dart';

import '../../domain/entities/task/TaskCommunication.dart';
import '../../domain/entities/task/TaskContent.dart';
import '../../domain/entities/task/TaskMeta.dart';
import 'CheckListModel.dart';
import 'CommentsModel.dart';



class TaskModel extends Tasks{
  TaskModel({required super.meta, required super.content, required super.communication});

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
    TaskModel(
      meta: TaskMeta.fromJson(json['meta'] as Map<String, dynamic>),
      content: TaskContent.fromJson(json['content'] as Map<String, dynamic>),
      communication: TaskCommunication.fromJson(json['communication'] as Map<String, dynamic>),

  );

  @override
  Map<String, dynamic> toJson() => {
    'meta': meta.toJson(),
    'content': content.toJson(),
    'communication': communication.toJson(),
  };

  //to entity
  Tasks toEntity() {
    return Tasks(
      meta: meta,
      content: content,
      communication: communication,
    );
  }
  // to json with only name and id
 static Map<String, dynamic> toJsonWithNameAndId(String name) {
    return {
      'meta': TaskMeta.empty(name).toJson(),
      'content':  TaskContent.empty().toJson(),
      'communication': TaskCommunication.empty().toJson(),
    };

  }

}