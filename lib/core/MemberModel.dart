
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jci_app/core/Member.dart';
import 'package:jci_app/features/MemberSection/data/model/UserObjectifsInfosModel.dart';
import 'package:json_annotation/json_annotation.dart';

import '../features/MemberSection/data/model/ObjectifsModels.dart';

@JsonSerializable()
class MemberModel extends Member{

factory MemberModel.fromEntity(Member member) {
    return MemberModel(
      roleName: member.roleName,
      points: member.points,
      id: member.id!,
      role: member.role,
      PreviousPoints: member.PreviousPoints,
      is_validated: member.is_validated,
      cotisation: member.cotisation,
      Images: member.Images,
      firstName: member.firstName,
      lastName: member.lastName,
      phone: member.phone,
      email: member.email,

      IsSelected: member.IsSelected,
      teams: member.teams,
      Activities: member.Activities,  language: member.language, rank: member.rank, description: member.description,
      board: member.board, isEmailVerified: member.isEmailVerified, userObjectifs: member.userObjectifs,
    );
  }
 MemberModel fromrole(String roleName) {
    return MemberModel(
      roleName: roleName,
      points: points,
      id: id!,
      role: role,
      PreviousPoints: PreviousPoints,
      is_validated: is_validated,
      cotisation: cotisation,
      Images: Images,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,

      IsSelected: IsSelected,
      teams: teams,
      Activities: Activities, userObjectifs: userObjectifs, language: language,
      rank: rank,
      description: description,
      board: board, isEmailVerified: isEmailVerified,
    );
  }



  factory MemberModel.fromJson(Map<String, dynamic> json) {

  return    MemberModel(
    roleName: json["roleName"]??"",

    PreviousPoints: json['PreviousPoints'] ?? 0,

    userObjectifs: json['userObjectifs'] == null ? [] : (json['userObjectifs'] ).map((e) => UserObjectifsModel.fromJson(e) ).toList(),
        points: json['points'] ?? json['Points'] ?? 0,
        id:  json['id'] ?? '',
        role: json['role'] != null
            ? (json['role'] is String
            ? FirebaseFirestore.instance.doc(json['role'] as String)
            : json['role'] as DocumentReference)
            : null,
        is_validated: json['is_validated'] ?? false,
        cotisation:
        json['cotisation'] == null ? [false,false ] :
        (json['cotisation'] as List<dynamic>).map((e) => e as bool).toList(),
        Images:
        json['Images'] ?? [] ,
        firstName: json['firstName'] ?? '',
        lastName: json['lastName']?? '' ,
        phone: json['phone'] ??"",
        email: json['email'] ?? "",


        IsSelected:false,
        teams: json['teams'] == null ? [] :json['teams'] as List<dynamic>,
        Activities:

        json['Activities'] == null ? [] :

        (json['Activities'] as List<dynamic>)
            .map((e) => e )
            .toList(), language: json['language'] ?? 'fr', rank: json['rank'] ?? json['Rank'] ?? 0, description: json['description'] ?? '', board: json['boardRole'] ?? '', isEmailVerified: json['isEmailVerified'] ?? false,
      );}
   MemberModel({required super.id, required super.role, required super.is_validated, required super.cotisation, required super.Images, required super.firstName, required super.lastName, required super.phone, required super.email,
      required super.IsSelected, required super.Activities, required super.teams, required super.points,  required super.language, required super.rank, required super.description, required super.board, required super.PreviousPoints,
     required super.isEmailVerified, required super.userObjectifs, required super.roleName});

  Map<String, dynamic> toJson() {
    return {
      'PreviousPoints': PreviousPoints,
      'userObjectifs': userObjectifs,
      'points': points,
      'id': id,
      'roleName':roleName,
      'role': role?.path,
      'is_validated': is_validated,
      'cotisation': cotisation,
      'Images': Images,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,


      'IsSelected': IsSelected,
      'teams': teams,
      'Activities': Activities,
      'language': language,
      'rank': rank,
      'description': description,
      'board': board,
      'isEmailVerified': isEmailVerified,
    };
  }

}