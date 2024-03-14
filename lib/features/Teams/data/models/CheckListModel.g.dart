// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CheckListModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckListModel _$CheckListModelFromJson(Map<String, dynamic> json) =>
    CheckListModel(
      name: json['name'] as String,
      Deadline: DateTime.parse(json['Deadline'] as String),
      isCompleted: json['isCompleted'] as bool,
      id: json['id'] as String,
    );

Map<String, dynamic> _$CheckListModelToJson(CheckListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'Deadline': instance.Deadline.toIso8601String(),
      'isCompleted': instance.isCompleted,
    };
