// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TeamModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamModel _$TeamModelFromJson(Map<String, dynamic> json) => TeamModel(
      name: json['name'] as String,
      description: json['description'] as String,
      event: json['event'],
      Members: json['Members'] as List<dynamic>,
      CoverImage: json['CoverImage'] as String,
      tasks: (json['tasks'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      id: json['id'] as String,
      TeamLeader: json['TeamLeader'],
      status: json['status'] as bool,
    );

Map<String, dynamic> _$TeamModelToJson(TeamModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'TeamLeader': instance.TeamLeader,
      'description': instance.description,
      'event': instance.event,
      'status': instance.status,
      'Members': instance.Members,
      'CoverImage': instance.CoverImage,
      'tasks': instance.tasks,
    };
