// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TaskModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
      name: json['name'] as String,
      AssignTo: json['AssignTo'] as String,
      Deadline: DateTime.parse(json['Deadline'] as String),
      attachedFile: (json['attachedFile'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      checkList:
          (json['checkList'] as List<dynamic>).map((e) => e as String).toList(),
      isCompleted: json['isCompleted'] as bool,
      id: json['id'] as String,
    );

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'AssignTo': instance.AssignTo,
      'Deadline': instance.Deadline.toIso8601String(),
      'attachedFile': instance.attachedFile,
      'checkList': instance.checkList,
      'isCompleted': instance.isCompleted,
    };
