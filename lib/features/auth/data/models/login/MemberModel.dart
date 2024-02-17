import 'package:jci_app/features/auth/domain/entities/LoginMember.dart';
import 'package:json_annotation/json_annotation.dart';


part 'MemberModel.g.dart';
@JsonSerializable()
class MemberModel extends Member {

  MemberModel({required super.email, required super.password});


  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemberModelToJson(this);
}

