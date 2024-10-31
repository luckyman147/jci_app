import 'package:json_annotation/json_annotation.dart';


import '../../../domain/entities/training.dart';

part 'TrainingModel.g.dart';
@JsonSerializable()
class TrainingModel extends Training{

  TrainingModel({required super.id,  required super.name, required super.description,
    required super.ActivityBeginDate, required super.ActivityEndDate, required super.ActivityAdress, required super.ActivityPoints,
    required super.categorie, required super.IsPaid, required super.price, required super.Participants, required super.CoverImages, required super.Duration,
    required super.ProfesseurName, required super.IsPart,   });

  factory TrainingModel.fromEntity(Training train)=>
  TrainingModel(
    id: train.id,
    name: train.name,
    description: train.description,
    ActivityBeginDate: train.ActivityBeginDate,
    ActivityEndDate: train.ActivityEndDate,
    ActivityAdress: train.ActivityAdress,
    ActivityPoints: train.ActivityPoints,
    categorie: train.categorie,
    IsPaid: train.IsPaid,
    price: train.price,
    Participants: train.Participants ?? [],
    CoverImages: train.CoverImages,
    Duration: train.Duration,
    ProfesseurName: train.ProfesseurName,
    IsPart: train.IsPart,

  );

  factory TrainingModel.fromJson(Map<String, dynamic> json) {
    return TrainingModel(
      id: json['id'] ?? json['_id'], // Use _id if id is null
      name: json['name'],
      description: json['description'],
      ActivityBeginDate: json['ActivityBeginDate'] != null ? DateTime.parse(json['ActivityBeginDate']) : DateTime.parse(json['ActivityBegindate']),
      ActivityEndDate: json['ActivityEndDate'] != null ? DateTime.parse(json['ActivityEndDate']) : DateTime.parse(json['ActivityEnddate']),
      ActivityAdress: json['ActivityAdress'],
      ActivityPoints: json['ActivityPoints'],
      categorie: json['categorie'],
      IsPaid: json['IsPaid'],
      price: json['price'],
      Participants: json['Participants'] != null ? (json['Participants'] as List<dynamic>).map((e) => e as String).toList() :(json['participants'] as List<dynamic>).toList(),
      CoverImages: json['CoverImages'] != null ? (json['CoverImages'] as List<dynamic>).map((e) => e as String).toList() : (json['coverImages'] as List<dynamic>).map((e) => e as String).toList(),
      Duration: json['Duration'],
      ProfesseurName: json['ProfesseurName'],
      IsPart: json['IsPart'],
    );
  }
  Map<String, dynamic> toJson() => _$TrainingModelToJson(this);
}
