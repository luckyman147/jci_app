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
      ActivityEndDate: DateTime.parse(json['ActivityEnddate'] as String),
      ActivityAdress: json['ActivityAdress'] as String,
      ActivityPoints: json['ActivityPoints'] as int,
      categorie: json['categorie'] as String,
      IsPaid: json['IsPaid'] as bool,

      price: 0,
      Participants: json['participants'] as List<dynamic>,
      CoverImages: (json['CoverImages'] as List<dynamic>)
          .map((e) => e as String?)
          .toList(),
      Director: json['Director'],
      Duration: json['Duration'] as int,

    );

Map<String, dynamic> _$MeetingModelToJson(MeetingModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'ActivityBegindate': instance.ActivityBeginDate.toIso8601String(),
      'ActivityEnddate': instance.ActivityEndDate.toIso8601String(),
      'ActivityAdress': instance.ActivityAdress,
      'ActivityPoints': instance.ActivityPoints,
      'categorie': instance.categorie,
      'IsPaid': instance.IsPaid,
      'price': instance.price,
      'participants': instance.Participants,
      'CoverImages': instance.CoverImages,
      '_id': instance.id,
      'Director': instance.Director,
      'Duration': instance.Duration,

    };
