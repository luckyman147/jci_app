// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EventModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
      id: json['_id'] == null ? json['id'] as String : json['_id'] as String,
      LeaderName: json['LeaderName'] == null
          ? ""
          : json['LeaderName'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      ActivityBeginDate:json['ActivityBegindate']!=null? DateTime.parse(json['ActivityBegindate'] as String):DateTime.parse(json['ActivityBeginDate'] as String),
      ActivityEndDate: json['ActivityEnddate']!=null?DateTime.parse(json['ActivityEnddate'] as String):DateTime.parse(json['ActivityEndDate'] as String),
      ActivityAdress: json['ActivityAdress'] as String,
      ActivityPoints: json['ActivityPoints'] as int,
      categorie: json['categorie'] as String,
      IsPaid: json['IsPaid'] as bool,
      price: json['price'] !=null ? json['price']as int: json['Price'] !=null ? json ["Price"]as int:0,
      IsPart: json['IsPart'] as bool,
      Participants:json['participants'] !=null?  json['participants'] as List<dynamic>:json['Participants'] as List<dynamic>,
    CoverImages: (json['CoverImages'] as List<dynamic>)
          .map((e) => e as String?)
          .toList(),
      registrationDeadline:
          DateTime.parse(json['registrationDeadline'] as String),
    );

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
      'IsPart': instance.IsPart,
      'Participants': instance.Participants,
      'CoverImages': instance.CoverImages,
      'LeaderName': instance.LeaderName,
      'registrationDeadline': instance.registrationDeadline.toIso8601String(),
    };
