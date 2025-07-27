import 'package:jci_app/features/Teams/domain/entities/Checklist.dart';
import 'package:json_annotation/json_annotation.dart';
part 'CheckListModel.g.dart';
@JsonSerializable()
class CheckListModel extends  CheckList{
  CheckListModel({required super.name, required super.isCompleted, required super.id});

  factory CheckListModel.fromJson(Map<String, dynamic> json , String? id) =>

  CheckListModel(
  name: json['name'] as String,

  isCompleted: json['isCompleted'] as bool,
  id: id ?? json['id'] as String? ?? '', // Ensure id is not null
  );
  static CheckListModel fromEntity(CheckList entity) {
    return CheckListModel(
      name: entity.name,
      id: entity.id,
      isCompleted: entity.isCompleted,
    );
  }
  CheckListModel copyWith({
    String? name,
    bool? isCompleted,
    String? id,
  }) {
    return CheckListModel(
      name: name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
      id: id ?? this.id,
    );
  }
  // ti json with only the name and isCompleted fields
  static Map<String, dynamic> toJsonForCreate(String name) {
    return {
      'name': name,
      'isCompleted': false,
    };
  }

  Map<String, dynamic> toJson() => _$CheckListModelToJson(this);
}