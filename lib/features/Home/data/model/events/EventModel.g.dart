// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EventModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
      id: json['id'] as String,
      LeaderName: json['LeaderName'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      ActivityBeginDate: DateTime.parse(json['ActivityBeginDate'] as String),
      ActivityEndDate: DateTime.parse(json['ActivityEndDate'] as String),
      ActivityAdress: json['ActivityAdress'] as String,
      ActivityPoints: (json['ActivityPoints'] as num).toInt(),
      categorie: json['categorie'] as String,
      IsPaid: json['IsPaid'] as bool,
      price: (json['price'] as num).toInt(),
      Participants: json['Participants'] as List<dynamic>,
      CoverImages: json['CoverImages'] as List<dynamic>,
      registrationDeadline:
          DateTime.parse(json['registrationDeadline'] as String),
      IsPart: json['IsPart'] as bool,
    )..tempPart = json['tempPart'] as bool;

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
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
      'LeaderName': instance.LeaderName,
      'registrationDeadline': instance.registrationDeadline.toIso8601String(),
    };
