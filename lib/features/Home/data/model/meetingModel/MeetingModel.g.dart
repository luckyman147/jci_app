// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MeetingModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeetingModel _$MeetingModelFromJson(Map<String, dynamic> json) => MeetingModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      ActivityBeginDate: DateTime.parse(json['ActivityBeginDate'] as String),
      ActivityEndDate: DateTime.parse(json['ActivityEndDate'] as String),
      ActivityAdress: json['ActivityAdress'] as String,
      ActivityPoints: json['ActivityPoints'] as int,
      categorie: json['categorie'] as String,
      IsPaid: json['IsPaid'] as bool,
      price: json['price'] as int,
      Participants: json['Participants'] as List<dynamic>,
      CoverImages: (json['CoverImages'] as List<dynamic>)
          .map((e) => e as String?)
          .toList(),
      Director: json['Director'],
      agenda:
          (json['agenda'] as List<dynamic>).map((e) => e as String).toList(),
      IsPart: json['IsPart'] as bool,
    )..tempPart = json['tempPart'] as bool;

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
      'tempPart': instance.tempPart,
      'IsPart': instance.IsPart,
      'Director': instance.Director,
      'agenda': instance.agenda,
    };
