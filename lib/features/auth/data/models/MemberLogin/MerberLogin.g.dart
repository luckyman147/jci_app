// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MerberLogin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberLogin _$MemberLoginFromJson(Map<String, dynamic> json) => MemberLogin(
      id: json['id'],
      role: json['role'],
      is_validated: json['is_validated'],
      cotisation: json['cotisation'],
      Images: json['Images'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      email: json['email'],
      password: json['password'], IsSelected: false,
    );

Map<String, dynamic> _$MemberLoginToJson(MemberLogin instance) =>
    <String, dynamic>{

      'email': instance.email,


      'password': instance.password,

    };
