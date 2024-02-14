import 'package:jci_app/features/auth/domain/entities/LoginMember.dart';

import '../../domain/entities/Member.dart';


class MemberModelSignUp extends MemberSignUp {

  MemberModelSignUp({required super.email, required super.password, required super.FirstName, required super.LastName, required super.confirmPassword})

;
  factory MemberModelSignUp.fromJson(Map<String, dynamic> json) {
    return MemberModelSignUp(

    email:  json['email'],
     password: json['password'],
    FirstName:   json['firstName'],
     LastName: json['lastName'], confirmPassword: json[''],);
  }

  Map<String, dynamic> toJson() {
    return {

      'email': email,
      'password': password,
      'firstName': FirstName,
      'lastName': LastName,
    };
  }
}
class MemberModel extends Member {

  MemberModel({required super.email, required super.password})

  ;
  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(

      email:  json['email'],
      password: json['password']) ;
  }

  Map<String, dynamic> toJson() {
    return {

      'email': email,
      'password': password,
    };
  }
}