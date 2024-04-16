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
  final String password;
  final bool is_validated;
  final List<bool> cotisation;
  final List<dynamic> Images;
  final List<dynamic> Activities;
  final List<dynamic> teams;
 final bool IsSelected;
 final int points;
 final List<dynamic> objectifs;

  final String role;

  factory  Member.fromImages(Map<String, dynamic> data) {
    return Member(

      points: data['points']??0,

      id: data['id']??data['_id'] ,
      email: data['email']??'',

      firstName: data['firstName'],
      lastName: data['lastName']??'',
      phone: data['phone']??'',
      password: data['password']??'',
      is_validated: data['is_validated']??false,
      cotisation: data['cotisation']??[],
      Images: data['Images'] as List<dynamic>,
      Activities: data['Activities']??[],
      teams: data['teams']??[],
      IsSelected: data['IsSelected']??false,
      role: data['role']??'', objectifs: [],
    );
  }


  static Member get memberTest=> const Member(

      IsSelected: false, id: "id", role: "role", is_validated: false,
      cotisation:[false] , Images: [] ,firstName: "", lastName: "lastName", phone: "phone", email: "email", password: "password", Activities: [], teams: [], points: 0, objectifs: []);

  static Member toMember(Map<String, dynamic> json) {
    return Member(
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
      role: json['role']??'',

    );
  }

  const Member(

      {
        required this.objectifs,
        required this.points,
        required this.teams,
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
       });


  @override
  // TODO: implement props
  List<Object?> get props => [email, password,teams,points,
    id, role, is_validated, cotisation, Images, firstName, lastName, phone,
    IsSelected, Activities

  ];}