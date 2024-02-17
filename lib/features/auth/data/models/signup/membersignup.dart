import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/Member.dart';



part 'membersignup.g.dart';

@JsonSerializable()
class MemberModelSignUp extends MemberSignUp {

  MemberModelSignUp({required super.email, required super.password, required super.FirstName, required super.LastName, required super.confirmPassword})

  ;
  factory MemberModelSignUp.fromJson(Map<String, dynamic> json) =>
      _$MemberModelSignUpFromJson(json);

  Map<String, dynamic> toJson() => _$MemberModelSignUpToJson(this);

}