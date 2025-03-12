// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EventModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$EventModelToJson(EventModel instance,{bool isDecode=false}) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'ActivityBeginDate': instance.ActivityBeginDate.toIso8601String(),
      'ActivityEndDate': instance.ActivityEndDate.toIso8601String(),
      'ActivityAdress': instance.ActivityAdress,
      'ActivityPoints': instance.ActivityPoints,
      'categorieId': instance.categorieId,
      'IsPaid': instance.IsPaid,
      'price': instance.price,
          "IsPublic": instance.IsPublic,
          'Participants': instance.Participants,
      'isOnline': instance.isOnline,
      'googleMeetLink': instance.googleMeetLink,
      'CoverImages': instance.CoverImages,
      'tempPart': instance.tempPart,
      'IsPart': instance.IsPart,
          "type": instance.type,
      'LeaderName': UserModel.fromEntity(instance.LeaderName).toJson(isDecode),
      'registrationDeadline': instance.registrationDeadline.toIso8601String(),
    };
