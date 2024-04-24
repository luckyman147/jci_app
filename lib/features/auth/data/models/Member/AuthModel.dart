import 'dart:developer';

import 'package:jci_app/features/auth/domain/entities/Member.dart';
import 'package:json_annotation/json_annotation.dart';
part 'AuthModel.g.dart';
@JsonSerializable()
class MemberModel extends Member{


factory MemberModel.fromEntity(Member member) {
    return MemberModel(
      points: member.points,
      id: member.id,
      role: member.role,
      is_validated: member.is_validated,
      cotisation: member.cotisation,
      Images: member.Images,
      firstName: member.firstName,
      lastName: member.lastName,
      phone: member.phone,
      email: member.email,
      password: member.password,
      IsSelected: member.IsSelected,
      teams: member.teams,
      Activities: member.Activities, objectifs: member.objectifs,
    );
  }

  factory MemberModel.fromJson(Map<String, dynamic> json) {
  log('message');

  return    MemberModel(
        objectifs: json['objectifs'] == null ? [] :json['objectifs'] as List<dynamic>,
        points: json['points'] ?? 0,
        id: json['_id']!=null ? json['_id']as String : json['id'] as String,
        role: json['role'] != null ? json['role'] as String : "member" ,
        is_validated: json['is_validated'] ?? false,
        cotisation:
        json['cotisation'] == null ? [false, ] :
        (json['cotisation'] as List<dynamic>).map((e) => e as bool).toList(),
        Images:
        json['Images'] ?? [] ,
        firstName: json['firstName'] as String,
        lastName: json['lastName']?? '' ,
        phone: json['phone'] ??"",
        email: json['email'] as String,
        password: "",
        IsSelected:false,
        teams: json['teams'] == null ? [] :json['teams'] as List<dynamic>,
        Activities:

        json['Activities'] == null ? [] :

        (json['Activities'] as List<dynamic>)
            .map((e) => e )
            .toList(),
      );}
  MemberModel({required super.id, required super.role, required super.is_validated, required super.cotisation, required super.Images, required super.firstName, required super.lastName, required super.phone, required super.email, required super.password, required super.IsSelected, required super.Activities, required super.teams, required super.points, required super.objectifs});

  Map<String, dynamic> toJson() => _$MemberModelToJson(this);

}