// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TrainingModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrainingModel _$TrainingModelFromJson(Map<String, dynamic> json) =>
    TrainingModel(
      id: json['id'] as String,
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
      Duration: (json['Duration'] as num).toInt(),
      ProfesseurName: json['ProfesseurName'] as String,
      IsPart: json['IsPart'] as bool,
    )..tempPart = json['tempPart'] as bool;

Map<String, dynamic> _$TrainingModelToJson(TrainingModel instance) =>
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
      'ProfesseurName': instance.ProfesseurName,
      'Duration': instance.Duration,
    };
