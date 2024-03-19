// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TaskModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************



Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'AssignTo': instance.AssignTo,
      'Deadline': instance.Deadline.toIso8601String(),
      'attachedFile': instance.attachedFile,
      'CheckList': instance.CheckLists,
      'StartDate': instance.StartDate.toIso8601String(),
      'description': instance.description,
      'isCompleted': instance.isCompleted,
    };
