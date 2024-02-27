import 'package:json_annotation/json_annotation.dart';


import '../../../domain/entities/training.dart';

part 'TrainingModel.g.dart';
@JsonSerializable()
class TrainingModel extends Training{

  TrainingModel({required super.id,  required super.name, required super.description,
    required super.ActivityBeginDate, required super.ActivityEndDate, required super.ActivityAdress, required super.ActivityPoints,
    required super.categorie, required super.IsPaid, required super.price, required super.Participants, required super.CoverImages, required super.Duration,
    required super.ProfesseurName,   });

  factory TrainingModel.fromJson(Map<String, dynamic> json) =>
      _$TrainingModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingModelToJson(this);
}
