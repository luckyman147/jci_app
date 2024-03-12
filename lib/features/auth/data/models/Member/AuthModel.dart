import 'package:jci_app/features/auth/domain/entities/Member.dart';
import 'package:json_annotation/json_annotation.dart';
part 'AuthModel.g.dart';
@JsonSerializable()
class MemberModel extends Member{




  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);

  MemberModel({required super.id, required super.role, required super.is_validated, required super.cotisation, required super.Images, required super.firstName, required super.lastName, required super.phone, required super.email, required super.password, required super.IsSelected, required super.Activities});

  Map<String, dynamic> toJson() => _$MemberModelToJson(this);

}