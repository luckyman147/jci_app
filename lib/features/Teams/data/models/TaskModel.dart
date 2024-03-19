import 'package:jci_app/features/Teams/domain/entities/Checklist.dart';
import 'package:jci_app/features/Teams/domain/entities/Task.dart';
import 'package:json_annotation/json_annotation.dart';

import 'CheckListModel.dart';
part 'TaskModel.g.dart';
@JsonSerializable()
class TaskModel extends Tasks{
  TaskModel({required super.name, required super.AssignTo,
    required super.Deadline, required super.attachedFile, required super.CheckLists, required super.isCompleted, required super.id, required super.StartDate, required super.description});

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      TaskModel(
        name: json['name'] as String,
        AssignTo:   json['AssignTo'] == null ? [] : (json['AssignTo'] as List<dynamic>)
           ,

        Deadline: DateTime.parse(json['Deadline'] as String),
        attachedFile:
        json['attachedFile'] == null ? [] : (json['attachedFile'] as List<dynamic>)
            .map((e) => e as String)
            .toList(),


        isCompleted: json['isCompleted'] as bool,
        id: json['id'] !=null? json['id'] as String : json['_id'] as String,


         StartDate: json['StartDate'] !=null ?  DateTime.parse(json['StartDate'] as String) : DateTime.now(),
        description: json['description'] != null ? json['description'] as String : "",
        CheckLists: json['CheckList'] == null ? [] : (json['CheckList'] as List<dynamic>)
            .map((e) => CheckListModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);
}