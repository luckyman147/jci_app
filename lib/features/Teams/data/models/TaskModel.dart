import 'package:jci_app/features/Teams/domain/entities/Task.dart';
import 'package:json_annotation/json_annotation.dart';
part 'TaskModel.g.dart';
@JsonSerializable()
class TaskModel extends Tasks{
  TaskModel({required super.name, required super.AssignTo, required super.Deadline, required super.attachedFile, required super.checkList, required super.isCompleted, required super.id});

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);
}