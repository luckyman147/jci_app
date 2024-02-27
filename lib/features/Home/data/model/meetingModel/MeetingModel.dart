import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/Meeting.dart';

part 'MeetingModel.g.dart';
@JsonSerializable()
class MeetingModel extends Meeting{

  MeetingModel({required super.id,  required super.name, required super.description,
    required super.ActivityBeginDate, required super.ActivityEndDate, required super.ActivityAdress, required super.ActivityPoints,
    required super.categorie, required super.IsPaid, required super.price, required super.Participants, required super.CoverImages,
    required super.Director, required super.Duration, });

  factory MeetingModel.fromJson(Map<String, dynamic> json) =>
      _$MeetingModelFromJson(json);

  Map<String, dynamic> toJson() => _$MeetingModelToJson(this);
}
