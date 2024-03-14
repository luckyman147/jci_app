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
      Images: json['Images'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      email: json['email'],
      password: json['password'],
      IsSelected: json['IsSelected'],
      Activities: json['Activities'],
    );

Map<String, dynamic> _$MemberSignupToJson(MemberSignup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'password': instance.password,
      'is_validated': instance.is_validated,
      'cotisation': instance.cotisation,
      'Images': instance.Images,
      'Activities': instance.Activities,
      'IsSelected': instance.IsSelected,
      'role': instance.role,
    };
