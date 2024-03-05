// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AuthModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberModel _$MemberModelFromJson(Map<String, dynamic> json) => MemberModel(
      id: json['_id'] != null ? json['_id'].toString() : json['id'] as String,
      role: json['role'] != null ? json['role'].toString() : "",
      is_validated:json['is_validated']!=null? json['is_validated'] as bool:false,
      cotisation:

      json["cotisation"]!=null?(json['cotisation'] as List<dynamic>).map((e) => e as bool).toList():[],
      Images:json["Images"]!=null? (json['Images'] as List<dynamic>).map((e) => e as String).toList():[],
      firstName: json['firstName'] as String,
      lastName: json['lastName']!=null? json['lastName'] as String:"",
      phone: json['phone']!=null? json['phone'] as String:"",
      email: json['email']!=null? json['email'] as String:"",
      password:"", IsSelected: false,
    );

Map<String, dynamic> _$MemberModelToJson(MemberModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'password': instance.password,
      'is_validated': instance.is_validated,
      'cotisation': instance.cotisation,
      'Images': instance.Images,
      'role': instance.role,
    };
