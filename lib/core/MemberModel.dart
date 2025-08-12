
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jci_app/core/Member.dart';
import 'package:jci_app/features/MemberSection/data/model/UserObjectifsInfosModel.dart';
import 'package:jci_app/features/MemberSection/domain/entity/Objectif.dart';
import 'package:json_annotation/json_annotation.dart';

import '../features/MemberSection/data/model/ObjectifsModels.dart';

@JsonSerializable()
class MemberModel extends Member{

factory MemberModel.fromEntity(Member member) {
    return MemberModel(
      unreadNotificationCount: member.unreadNotificationCount,
      notificationCount: member.notificationCount,
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
      board: board, isEmailVerified: isEmailVerified, unreadNotificationCount: unreadNotificationCount,notificationCount: notificationCount
    );
  }



  factory MemberModel.fromJson(Map<String, dynamic> json) {

  return    MemberModel(
    roleName: json["roleName"]??"",

      PreviousPoints: (json['PreviousPoints'] ?? 0).toInt(),
      points: (json['points'] ?? 0).toInt(),


    userObjectifs: json['userObjectifs'] == null ? [] : (json['userObjectifs'] ).map((e) => UserObjectifsModel.fromJson(e) ).toList(),
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
    notificationCount:
    json["notificationCount"]??0,
    unreadNotificationCount: json["unreadNotificationCount"]??0
      );}
   MemberModel({required super.id, required super.role, required super.is_validated, required super.cotisation, required super.Images, required super.firstName, required super.lastName, required super.phone, required super.email,
      required super.IsSelected, required super.Activities, required super.teams, required super.points,
     required super.notificationCount,required super.unreadNotificationCount,

     required super.language, required super.rank, required super.description, required super.board, required super.PreviousPoints,
     required super.isEmailVerified, required super.userObjectifs, required super.roleName});

  Map<String, dynamic> toJson() {
    return {
      "unreadNotificationCount":unreadNotificationCount,
      "notificationCount":notificationCount,
      'PreviousPoints': PreviousPoints,
      'points': points,
      'id': id,
      'roleName':roleName,
      'role': role!.path,
      'is_validated': is_validated,
      'cotisation': cotisation,
      'Images': Images,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,


      'IsSelected': IsSelected,
      'teams': teams,
      'Activities': [],
      'language': language,
      'rank': rank,
      'description': description,
      'board': board,
      'isEmailVerified': isEmailVerified,
    };
  }

MemberModel copyWith({
  String? id,
  DocumentReference? role,
  bool? is_validated,
  List<bool>? cotisation,
  List<String>? Images,
  String? firstName,
  String? lastName,
  String? phone,
  String? email,
  bool? IsSelected,
  List<dynamic>? Activities,
  List<dynamic>? teams,
  int? points,
  int? notificationCount,
  int? unreadNotificationCount,
  String? language,
  int? rank,
  String? description,
  String? board,
  int? PreviousPoints,
  bool? isEmailVerified,
  List<UserObjectif>? userObjectifs,
  String? roleName,
}) {
  return MemberModel(
    id: id ?? this.id,
    role: role ?? this.role,
    is_validated: is_validated ?? this.is_validated,
    cotisation: cotisation ?? this.cotisation,
    Images: Images ?? this.Images,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    IsSelected: IsSelected ?? this.IsSelected,
    Activities: Activities ?? this.Activities,
    teams: teams ?? this.teams,
    points: points ?? this.points,
    notificationCount: notificationCount ?? this.notificationCount,
    unreadNotificationCount: unreadNotificationCount ?? this.unreadNotificationCount,
    language: language ?? this.language,
    rank: rank ?? this.rank,
    description: description ?? this.description,
    board: board ?? this.board,
    PreviousPoints: PreviousPoints ?? this.PreviousPoints,
    isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    userObjectifs: userObjectifs ?? this.userObjectifs,
    roleName: roleName ?? this.roleName,
  );
}


}