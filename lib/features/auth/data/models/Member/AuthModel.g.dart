// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AuthModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberModel _$MemberModelFromJson(Map<String, dynamic> json) => MemberModel(
      id: json['id'] as String,
      role: json['role'] as String,
      is_validated: json['is_validated'] as bool,
      cotisation:
          (json['cotisation'] as List<dynamic>).map((e) => e as bool).toList(),
      Images:
          (json['Images'] as List<dynamic>).map((e) => e as String).toList(),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      IsSelected: json['IsSelected'] as bool,
      Activities: (json['Activities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MemberModelToJson(MemberModel instance) =>
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
