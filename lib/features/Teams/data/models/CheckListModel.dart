import 'package:jci_app/features/Teams/domain/entities/Checklist.dart';
import 'package:json_annotation/json_annotation.dart';
part 'CheckListModel.g.dart';
@JsonSerializable()
class CheckListModel extends  CheckList{
  CheckListModel({required super.name, required super.isCompleted, required super.id});

  factory CheckListModel.fromJson(Map<String, dynamic> json) =>

  CheckListModel(
  name: json['name'] as String,

  isCompleted: json['isCompleted'] as bool,
  id: json['id'] !=null? json['id'] as String : json['_id'] as String
  );
  static CheckListModel fromEntity(CheckList entity) {
    return CheckListModel(
      name: entity.name,
      id: entity.id,
      isCompleted: entity.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => _$CheckListModelToJson(this);
}