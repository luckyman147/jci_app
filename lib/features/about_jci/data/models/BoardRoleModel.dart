import 'package:jci_app/features/about_jci/Domain/entities/BoardRole.dart';
import 'package:json_annotation/json_annotation.dart';
@JsonSerializable()
class BoardRoleModel extends BoardRole{
  BoardRoleModel({required super.id, required super.name, required super.priority});
factory BoardRoleModel.fromJson(Map<String, dynamic> json) {
    return BoardRoleModel(
      id: json['_id'],
      name: json['name'],
      priority: json['priority'],
    );
  }
  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'priority': priority,
  };

}