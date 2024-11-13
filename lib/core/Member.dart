import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:jci_app/core/Abstractions/Entity.dart';

class Member extends Entity<String> {
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String description;
  final dynamic board;
  final String password;
  final bool is_validated;
  final List<bool> cotisation;
  final List<dynamic> Images;
  final List<dynamic> Activities;
  final List<dynamic> teams;
  final bool IsSelected;
  final String language;
  final int points;
  final int PreviousPoints;
  final List<dynamic> objectifs;
  final int rank;
  final String role;
  final bool isEmailVerified ;



  factory Member.fromImages(Map<String, dynamic> data) {
    log('hey');
    return Member(
      PreviousPoints: data['PreviousPoints'] ?? 0,
      language: data['language'] ?? 'fr',
      points: data['points'] ?? 0,
      id: data['id'] ?? data['_id'] ?? "", // Setting inherited id here
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      phone: data['phone'] ?? '',
      password: data['password'] ?? '',
      is_validated: data['is_validated'] ?? false,
      cotisation: data['cotisation'] ?? [],
      Images: data['Images'] as List<dynamic>,
      Activities: data['Activities'] ?? [],
      teams: data['teams'] ?? [],
      IsSelected: data['IsSelected'] ?? false,
      role: data['role'] ?? '',
      objectifs: const [],
      rank: data['rank'] ?? -1,
      description: data['description'] ?? '',
      board: data['boardRole'] ?? '', isEmailVerified: true,
    );
  }

  static Member get memberTest =>  Member(
      language: "fr",
      IsSelected: false,
      id: "id",

      role: "role",
      is_validated: false,
      cotisation: [false],
      Images: [],
      firstName: "",
      lastName: "lastName",
      phone: "phone",
      email: "email",
      password: "password",
      Activities: [],
      teams: [],
      points: 0,
      objectifs: [],
      rank: 0,
      description: '',
      board: '',
      PreviousPoints: 0, isEmailVerified: true);

  static Member toMember(Map<String, dynamic> json) {
    return Member(
      description: json['description'] ?? '',
      PreviousPoints: json['PreviousPoints'] ?? 0,
      board: json['boardRole'] ?? '',
      language: json['language'] ?? 'fr',
      objectifs: json['objectifs'] ?? [],
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
      password: json['password'] ?? '',
      is_validated: json['is_validated'] ?? false,
      cotisation: json['cotisation'] ?? [],
      role: json['role'] ?? '',
      rank: json['rank'] ?? -1, isEmailVerified: json['isEmailVerified'] ?? false,
    );
  }

   Member({
     required this .isEmailVerified,
    required this.objectifs,
    required this.PreviousPoints,
    required this.points,
    required this.teams,
    required this.description,
    required this.board,
    required this.language,
    required this.Activities,
    required this.IsSelected,
    required String id, // Use inherited id property from Entity<String>
    required this.role,
    required this.is_validated,
    required this.cotisation,
    required this.Images,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.password,
    required this.rank,
  }) : super() {
    this.id = id; // Setting id through inherited property
  }

  @override
  List<Object?> get props => [
    email,
    password,
    teams,
    points,
    id, // inherited id
    role,
    is_validated,
    cotisation,
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
    objectifs,
    PreviousPoints,
  ];

  @override
  bool? get stringify => true;
}
