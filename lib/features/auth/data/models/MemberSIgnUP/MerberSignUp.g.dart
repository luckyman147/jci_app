// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MerberSignUp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberSignup _$MemberSignupFromJson(Map<String, dynamic> json) => MemberSignup(
      id: json['id'],
      role: json['role'],
      is_validated: json['is_validated'],
      cotisation: json['cotisation'],
      Activities: json['Activities'],
      Images: json['Images'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      email: json['email'],
      password: json['password'],
      IsSelected: false,
    );

Map<String, dynamic> _$MemberSignupToJson(MemberSignup instance) =>
    <String, dynamic>{

      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,

      'password': instance.password,

    };
