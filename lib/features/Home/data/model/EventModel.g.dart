// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EventModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
      name: json['name'] as String,
      ActivityBeginDate: DateTime.parse(json['ActivityBeginDate'] as String),
      ActivityEndDate: DateTime.parse(json['ActivityEndDate'] as String),
      ActivityAdress: json['ActivityAdress'] as String,
      Participants: json['Participants'] as List<dynamic>,
      CoverImages: (json['CoverImages'] as List<dynamic>)
          .map((e) => e as String?)
          .toList(),
      LeaderName: json['LeaderName'] as String,
      id: json['_id'] as String,
    );

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'LeaderName': instance.LeaderName,
      'name': instance.name,
      'ActivityBeginDate': instance.ActivityBeginDate.toIso8601String(),
      'ActivityEndDate': instance.ActivityEndDate.toIso8601String(),
      'Participants': instance.Participants,
      'CoverImages': instance.CoverImages,
      'ActivityAdress': instance.ActivityAdress,
    };
