

import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/Event.dart';

part 'EventModel.g.dart';
@JsonSerializable()
class EventModel extends Event{

  EventModel({required super.name, required super.ActivityBeginDate,
    required super.ActivityEndDate, required super.ActivityAdress, required super.Participants,
    required super.CoverImages, required super.LeaderName, required super.id,});

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventModelToJson(this);
}