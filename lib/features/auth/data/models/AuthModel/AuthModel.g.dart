// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AuthModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

modelAuth _$modelAuthFromJson(Map<String, dynamic> json) => modelAuth(
      id: json['_id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String,
      is_validated: json['is_validated'] as bool,
      cotisation: json['cotisation'] as List<dynamic>,
      Images: json['Images'] as List<dynamic>,
      role: json['role'] as String,
    );

Map<String, dynamic> _$modelAuthToJson(modelAuth instance) => <String, dynamic>{
      '_id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'is_validated': instance.is_validated,
      'cotisation': instance.cotisation,
      'Images': instance.Images,
      'role': instance.role,
    };
