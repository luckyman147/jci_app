import 'package:jci_app/features/Teams/domain/entities/Checklist.dart';
import 'package:json_annotation/json_annotation.dart';
part 'CheckListModel.g.dart';
@JsonSerializable()
class CheckListModel extends  CheckList{
  CheckListModel({required super.name, required super.Deadline, required super.isCompleted, required super.id});

  factory CheckListModel.fromJson(Map<String, dynamic> json) =>
      _$CheckListModelFromJson(json);

  Map<String, dynamic> toJson() => _$CheckListModelToJson(this);
}