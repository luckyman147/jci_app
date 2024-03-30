// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FileModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileModel _$FileModelFromJson(Map<String, dynamic> json) => FileModel(
      url: json['url'] as String,
      id: json['id'] ?? json['_id'],
      path: json['path'] as String,
      extension: json['extension'] as String,
    );

Map<String, dynamic> _$FileModelToJson(FileModel instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'path': instance.path,
      'extension': instance.extension,
    };
