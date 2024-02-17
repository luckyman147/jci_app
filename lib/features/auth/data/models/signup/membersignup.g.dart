// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membersignup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberModelSignUp _$MemberModelSignUpFromJson(Map<String, dynamic> json) =>
    MemberModelSignUp(
      email: json['email'] as String,
      password: json['password'] as String,
      FirstName: json['FirstName'] as String,
      LastName: json['LastName'] as String,
      confirmPassword: json['confirmPassword'] as String,
    );

Map<String, dynamic> _$MemberModelSignUpToJson(MemberModelSignUp instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'FirstName': instance.FirstName,
      'LastName': instance.LastName,
      'confirmPassword': instance.confirmPassword,
    };
