// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AuthModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

modelAuth _$modelAuthFromJson(Map<String, dynamic> json) => modelAuth(
      email: json['email'] as String,

      role: json['role'] as String,
    );

Map<String, dynamic> _$modelAuthToJson(modelAuth instance) => <String, dynamic>{
      'email': instance.email,

      'role': instance.role,
    };
