

import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/Event.dart';


part 'EventModel.g.dart';
@JsonSerializable()
class EventModel extends Event{

  EventModel({required super.id, required super.LeaderName, required super.name, required super.description,
    required super.ActivityBeginDate, required super.ActivityEndDate, required super.ActivityAdress, required super.ActivityPoints,
    required super.categorie, required super.IsPaid, required super.price, required super.Participants,
    required super.CoverImages, required super.registrationDeadline,});

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventModelToJson(this);
}


