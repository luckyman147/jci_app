import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:jci_app/core/Abstractions/Entity.dart';

import '../features/MemberSection/domain/entity/Objectif.dart';
import 'PrimitiveUser/User.dart';

class Member extends User {

  final String phone;
  final String description;
  final dynamic board;

  final bool is_validated;
  final List<bool> cotisation;

  final List<dynamic> Activities;
  final List<dynamic> teams;
  final bool IsSelected;
  final String language;
  final double points;
  final double PreviousPoints;
final int notificationCount;
final int unreadNotificationCount;
  final int rank;
final bool isEmailVerified;
final List<UserObjectif> userObjectifs;

final String roleName;


  factory Member.fromImages(Map<String, dynamic> data) {
    log('hey');
    return Member(
      roleName: data['roleName']??"",
      userObjectifs: data['userObjectifs']??[],
      PreviousPoints: data['PreviousPoints'] ?? 0,
      language: data['language'] ?? 'fr',
      points: data['points'] ?? 0,
      id: data['id'] ?? data['_id'] ?? "", // Setting inherited id here
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      phone: data['phone'] ?? '',

      is_validated: data['is_validated'] ?? false,
      cotisation: data['cotisation'] ?? [],
      Images: data['Images'] as List<dynamic>,
      Activities: data['Activities'] ?? [],
      teams: data['teams'] ?? [],
      IsSelected: data['IsSelected'] ?? false,
      role: data['role'] ?? '',

      rank: data['rank'] ?? -1,
      description: data['description'] ?? '',
      board: data['boardRole'] ?? '', isEmailVerified: true,
    );
  }

  Member({required this.phone, required this.description, required this.board, required this.is_validated, required this.cotisation, required this.Activities, required this.teams, required this.IsSelected, required this.language, required this.points, required this.PreviousPoints,
    required this.rank, required this.isEmailVerified,
  required super.email,  required super.id, required super.role, required super.Images, required super.firstName, required super.lastName,
required this.userObjectifs, this.roleName="", this.notificationCount=0, this.unreadNotificationCount=0
  });

  static Member get memberTest =>  Member(
      language: "fr",
      IsSelected: false,
      id: "id",
      roleName: "",

      role: null,
      is_validated: false,
      cotisation: const [false],
      Images: const [],
      firstName: "",
      lastName: "lastName",
      phone: "phone",
      email: "email",

      Activities: const [],
      teams: const [],
      points: 0,

      rank: 0,
      description: '',
      board: '',
      PreviousPoints: 0, isEmailVerified: true, userObjectifs: []);

  static Member toMember(Map<String, dynamic> json) {
    return Member(
      roleName: json["roleName"]??"",
      description: json['description'] ?? '',
      PreviousPoints: json['PreviousPoints'] ?? 0,
      board: json['boardRole'] ?? '',
      language: json['language'] ?? 'fr',
      userObjectifs: json['userObjectifs'] ?? [],
      points: json['points'] ?? 0,
      id: json['_id'] == null ? json['id'] as String : json['_id'] as String,
      firstName: json['firstName'] as String,
      Images: json['Images'],
      Activities: json['Activities'] ?? [],
      teams: json['teams'] ?? [],
      IsSelected: json['IsSelected'] ?? false,
      email: json['email'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'] ?? '',

      is_validated: json['is_validated'] ?? false,
      cotisation: json['cotisation'] ?? [],
      role: json['role'] ?? '',
      rank: json['rank'] ?? -1, isEmailVerified: json['isEmailVerified'] ?? false,
    );
  }


  @override
  List<Object?> get props => [
    email,

    teams,
    points,
    id, // inherited id
    role,
    is_validated,
    cotisation,
    roleName,
    Images,
    firstName,
    lastName,
    phone,
    IsSelected,
    Activities,
    rank,
    description,
    board,
    language,
    userObjectifs,
    PreviousPoints,
  ];

  @override
  bool? get stringify => true;
}
