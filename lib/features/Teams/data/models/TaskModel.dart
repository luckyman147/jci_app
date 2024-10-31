import 'package:jci_app/features/Teams/domain/entities/Task.dart';
import 'package:json_annotation/json_annotation.dart';

import 'CheckListModel.dart';
import 'CommentsModel.dart';
import 'FileModel.dart';


class TaskModel extends Tasks{
  TaskModel({required super.name, required super.AssignTo,
    required super.Deadline, required super.attachedFile, required super.CheckLists, required super.isCompleted, required super.id, required super.StartDate, required super.description, required super.comments});

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      TaskModel(
    comments: json['comments'] == null
        ? []
        : (json['comments'] as List<dynamic>).map((e) => CommentModel.fromJson(e as Map<String, dynamic>)).toList().cast(),
        name: json['name'] as String,
        AssignTo:   json['AssignTo'] == null ? [] : (json['AssignTo'] as List<dynamic>)
           ,

        Deadline: json['Deadline'] != null  ?  json['Deadline'].runtimeType!=DateTime  ?     DateTime.parse(json['Deadline']) :json["Deadline"]: DateTime.now() ,
        attachedFile:
        json['attachedFile'] == null ? [] : (json['attachedFile'] as List<dynamic>)
            .map((e) => FileModel.fromJson(e as Map<String, dynamic>))
            .toList(),


        isCompleted: json['isCompleted'] as bool,
        id: json['id'] !=null? json['id'] as String : json['_id'] as String,


        StartDate: json['StartDate'] != null ?  json["StartDate"].runtimeType!=DateTime?       DateTime.parse(json['StartDate']):json['StartDate'] : DateTime.now(),
        description: json['description'] != null ? json['description'] as String : "",
        CheckLists: json['CheckList'] == null ? [] :


        (json['CheckList'] as List<dynamic>)
            .map((e) => CheckListModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  Map<String, dynamic> toJson() => {
    'name': name,
    'AssignTo': AssignTo,
    'Deadline': Deadline.toIso8601String(),
    'attachedFile': attachedFile,
    'CheckList': CheckLists,
    'isCompleted': isCompleted,



    'id': id,
    'StartDate': StartDate.toIso8601String(),
    'description': description,
  };
}