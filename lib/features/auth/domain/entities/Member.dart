import 'package:equatable/equatable.dart';
import 'package:jci_app/features/auth/presentation/widgets/inputs.dart';

import '../../../Home/domain/entities/Activity.dart';

class Member extends Equatable {
  final String id;

  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String password;
  final bool is_validated;
  final List<bool> cotisation;
  final List<dynamic> Images;final List<String> Activities;
 final bool IsSelected;

  final String role;

  factory  Member.fromImages(Map<String, dynamic> data) {
    return Member(
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
      IsSelected: data['IsSelected']??false,
      role: data['role']??'',
    );
  }

  static Member toMember(Map<String, dynamic> json) {
    return Member(
      id: json['_id'] ==null?json['id'] as String:json['_id'] as String,
      firstName: json['firstName']as String,
      Images: json['Images'] as List<dynamic>,
      // null
      Activities: json['Activities']??[],
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
  List<Object?> get props => [email, password,
    id, role, is_validated, cotisation, Images, firstName, lastName, phone,
    IsSelected, Activities

  ];}