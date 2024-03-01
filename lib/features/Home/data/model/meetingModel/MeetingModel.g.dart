// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MeetingModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeetingModel _$MeetingModelFromJson(Map<String, dynamic> json) => MeetingModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      ActivityBeginDate: DateTime.parse(json['ActivityBegindate'] as String),
      ActivityEndDate: DateTime.now(),
      ActivityAdress: "Local Menchia Hammam Sousse",
      ActivityPoints: json['ActivityPoints'] as int,
      categorie: json['categorie'] as String,
      IsPaid: false,
      price: 0,
      Participants: json['Participants'] as List<dynamic>,
      CoverImages: [],
      Director: json['Director'],
      agenda:
          (json['agenda'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$MeetingModelToJson(MeetingModel instance) =>
    <String, dynamic>{

      'name': instance.name,
      'description': instance.description,
      'ActivityBeginDate': instance.ActivityBeginDate.toIso8601String(),


      'ActivityPoints': instance.ActivityPoints,
      'categorie': instance.categorie,

      'Participants': instance.Participants,

      'Director': instance.Director,
      'agenda': instance.agenda,
    };
