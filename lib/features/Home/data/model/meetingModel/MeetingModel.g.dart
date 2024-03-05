// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MeetingModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeetingModel _$MeetingModelFromJson(Map<String, dynamic> json) => MeetingModel(
      id: json['_id'] !=null? json['_id']  as String: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      ActivityBeginDate:json['ActivityBegindate']!=null? DateTime.parse(json['ActivityBegindate'] as String):DateTime.parse(json['ActivityBeginDate'] as String),

      ActivityEndDate: DateTime.now(),
      ActivityAdress: "Local Menchia Hammem sousse",
      ActivityPoints:0,
      categorie: json['categorie'] as String,
      IsPaid: false,
      price: 0,
      Participants:json['participants'] !=null?  json['participants'] as List<dynamic>:json['Participants'] as List<dynamic>,
      CoverImages:[],
      Director: json['Director'],
      agenda:json['Agenda']!=null?
          (json['Agenda'] as List<dynamic>).map((e) => e as String).toList(): (json['agenda'] as List<dynamic>).map((e) => e as String).toList()
    );

Map<String, dynamic> _$MeetingModelToJson(MeetingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'ActivityBeginDate': instance.ActivityBeginDate.toIso8601String(),
      'ActivityEndDate': instance.ActivityEndDate.toIso8601String(),
      'ActivityAdress': instance.ActivityAdress,
      'ActivityPoints': instance.ActivityPoints,
      'categorie': instance.categorie,
      'IsPaid': instance.IsPaid,
      'price': instance.price,
      'Participants': instance.Participants,
      'CoverImages': instance.CoverImages,
      'Director': instance.Director,
      'agenda': instance.agenda,
    };
