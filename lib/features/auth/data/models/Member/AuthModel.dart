
import 'package:jci_app/features/auth/domain/entities/Member.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class MemberModel extends Member{

factory MemberModel.fromEntity(Member member) {
    return MemberModel(
      points: member.points,
      id: member.id,
      role: member.role,
      PreviousPoints: member.PreviousPoints,
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
      Activities: member.Activities, objectifs: member.objectifs, language: member.language, rank: member.rank, description: member.description, board: member.board,
    );
  }

  factory MemberModel.fromJson(Map<String, dynamic> json) {

  return    MemberModel(
    PreviousPoints: json['PreviousPoints'] ?? 0,

        objectifs: json['objectifs'] == null ? [] :json['objectifs'] as List<dynamic>,
        points: json['points'] ?? json['Points'] ?? 0,
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
        email: json['email'] ?? "",
        password: "",

        IsSelected:false,
        teams: json['teams'] == null ? [] :json['teams'] as List<dynamic>,
        Activities:

        json['Activities'] == null ? [] :

        (json['Activities'] as List<dynamic>)
            .map((e) => e )
            .toList(), language: json['language'] ?? 'fr', rank: json['rank'] ?? json['Rank'] ?? 0, description: json['description'] ?? '', board: json['boardRole'] ?? '',
      );}
  const MemberModel({required super.id, required super.role, required super.is_validated, required super.cotisation, required super.Images, required super.firstName, required super.lastName, required super.phone, required super.email, required super.password, required super.IsSelected, required super.Activities, required super.teams, required super.points, required super.objectifs, required super.language, required super.rank, required super.description, required super.board, required super.PreviousPoints});

  Map<String, dynamic> toJson() {
    return {
      'PreviousPoints': PreviousPoints,
      'objectifs': objectifs,
      'points': points,
      'id': id,
      'role': role,
      'is_validated': is_validated,
      'cotisation': cotisation,
      'Images': Images,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'password': password,
      'IsSelected': IsSelected,
      'teams': teams,
      'Activities': Activities,
      'language': language,
      'rank': rank,
      'description': description,
      'board': board,
    };
  }

}