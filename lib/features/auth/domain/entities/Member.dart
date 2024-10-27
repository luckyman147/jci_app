import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:jci_app/features/auth/presentation/widgets/inputs.dart';

import '../../../Home/domain/entities/Activity.dart';
import '../../../Teams/domain/entities/TaskFile.dart';

class Member extends Equatable {
  final String id;

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

  factory Member.SignUp(String email,String password,String firstName,String lastName,String language,String role) {
    return Member(
      language: language,
      points: 0,
      PreviousPoints: 0,
      id: '',
      email: email,
      firstName: firstName,
      lastName: lastName,
      phone: '',
      password: password,
      is_validated: false,
      cotisation: [false],
      Images: [],
      Activities: [],
      teams: [],
      IsSelected: false,
      role: role,
      objectifs: [], rank: 0, description: '', board: '',
    );
  }












  factory  Member.fromImages(Map<String, dynamic> data) {
    log('hey');
    return Member(
      PreviousPoints: data['PreviousPoints']??0,
      language: data['language']??'fr',

      points: data['points']??0,

      id: data['id']??data['_id']??"",
      email: data['email']??'',

      firstName: data['firstName']??'',
      lastName: data['lastName']??'',
      phone: data['phone']??'',
      password: data['password']??'',
      is_validated: data['is_validated']??false,
      cotisation: data['cotisation']??[],
      Images: data['Images'] as List<dynamic>,
      Activities: data['Activities']??[],
      teams: data['teams']??[],
      IsSelected: data['IsSelected']??false,
      role: data['role']??'', objectifs: [], rank: data['rank']??-1, description: data['description']??'', board: data['boardRole']??'',
    );
  }


  static Member get memberTest=> const Member(
      language: "fr",

      IsSelected: false, id: "id", role: "role", is_validated: false,
      cotisation:[false] , Images: [] ,firstName: "", lastName: "lastName", phone: "phone", email: "email", password: "password", Activities: [], teams: [], points: 0, objectifs: [], rank: 0, description: '', board: '', PreviousPoints: 0);

  static Member toMember(Map<String, dynamic> json) {
    return Member(
      description: json['description']??'',
      PreviousPoints: json['PreviousPoints']??0,
      board: json['boardRole']??'',
      language: json['language']??'fr',
      objectifs: json['objectifs']??[],
      points: json['points']??0,
      id: json['_id'] ==null?json['id'] as String:json['_id'] as String,
      firstName: json['firstName']as String,
      Images: json['Images'] ,
      // null
      Activities: json['Activities']??[],
      teams: json['teams']??[],
      IsSelected: json['IsSelected']??false,
      //null
      email: json['email']??'',
      lastName: json['lastName']??'',
      phone: json['phone']??'',
      password: json['password']??'',
      is_validated: json['is_validated']??false,
      cotisation: json['cotisation']??[],
      role: json['role']??'', rank: json['rank']??-1

    );
  }

  const Member(

      {
        required this.objectifs,
        required this.PreviousPoints,
        required this.points,
        required this.teams,
        required this.description,
        required this.board,
        required this.language,
        required this.Activities,
        required this.IsSelected,
        required this.id,
        required this.role,
        required this.is_validated,
        required this.cotisation,
        required this.Images,
        required this.firstName,
        required this.lastName,
         required this.phone,
        required this.email,
        required this.password,
         required this.rank
       });


  @override
  // TODO: implement props
  List<Object?> get props => [email, password,teams,points,
    id, role, is_validated, cotisation, Images, firstName, lastName, phone,
    IsSelected, Activities,rank, description, board, language, objectifs, PreviousPoints

  ];}