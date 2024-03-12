// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TrainingModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrainingModel _$TrainingModelFromJson(Map<String, dynamic> json) =>
    TrainingModel(
          id: json['_id'] !=null? json['_id']  as String: json['id'] as String,

      name: json['name'] as String,
      description: json['description'] as String,
          ActivityBeginDate:json['ActivityBegindate']!=null? DateTime.parse(json['ActivityBegindate'] as String):DateTime.parse(json['ActivityBeginDate'] as String),
          ActivityEndDate: json['ActivityEnddate']!=null?DateTime.parse(json['ActivityEnddate'] as String):DateTime.parse(json['ActivityEndDate'] as String),
      ActivityAdress: json['ActivityAdress'] as String,
      ActivityPoints: json['ActivityPoints'] as int,
      categorie: json['categorie'] as String,
      IsPaid: json['IsPaid'] as bool,
      IsPart: json['IsPart'] as bool,

      price: json['price'] !=null ? json['price']as int: json['Price'] !=null ? json ["Price"]as int:0,
          Participants:json['participants'] !=null?  json['participants'] as List<dynamic>:json['Participants'] as List<dynamic>,

      CoverImages: (json['CoverImages'] as List<dynamic>)
          .map((e) => e as String?)
          .toList(),
      Duration: json['Duration'] as int,
      ProfesseurName: json['ProfesseurName'] as String,
    );

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
      'price': instance.price,      'IsPart': instance.IsPart,


      'Participants': instance.Participants,
      'CoverImages': instance.CoverImages,
      'ProfesseurName': instance.ProfesseurName,
      'Duration': instance.Duration,
    };
