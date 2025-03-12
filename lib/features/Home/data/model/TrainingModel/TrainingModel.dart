import 'package:jci_app/features/Home/Activity_Global.dart';
import 'package:jci_app/features/Home/domain/entities/ParticipantDetailsParam.dart';
import 'package:json_annotation/json_annotation.dart';


import '../../../domain/entities/training.dart';

part 'TrainingModel.g.dart';
@JsonSerializable()
class TrainingModel extends Training{

  TrainingModel({required super.id,  required super.name, required super.description,
    required super.ActivityBeginDate, required super.ActivityEndDate, required super.ActivityAdress, required super.ActivityPoints,
    required super.categorieId, required super.IsPaid, required super.price, required super.Participants, required super.CoverImages, required super.Duration,
    required super.ProfesseurName, required super.IsPart, required super.IsPublic, required super.isOnline, required super.googleMeetLink,   });

  factory TrainingModel.fromEntity(Training train)=>
  TrainingModel(
    isOnline: train.isOnline,
    googleMeetLink: train.googleMeetLink,
    id: train.id,
    name: train.name,
    description: train.description,
    ActivityBeginDate: train.ActivityBeginDate,
    ActivityEndDate: train.ActivityEndDate,
    ActivityAdress: train.ActivityAdress,
    ActivityPoints: train.ActivityPoints,
    categorieId: train.categorieId,
    IsPaid: train.IsPaid,
    price: train.price,
    Participants: train.Participants ?? [],
    CoverImages: train.CoverImages,
    Duration: train.Duration,
    ProfesseurName: train.ProfesseurName,
    IsPart: train.IsPart, IsPublic: train.IsPublic,

  );
  factory TrainingModel.SetImages(TrainingModel train,List<String> images)=>
  TrainingModel(
    isOnline: train.isOnline,
    googleMeetLink: train.googleMeetLink,
    id: train.id,
    name: train.name,
    description: train.description,
    ActivityBeginDate: train.ActivityBeginDate,
    ActivityEndDate: train.ActivityEndDate,
    ActivityAdress: train.ActivityAdress,
    ActivityPoints: train.ActivityPoints,
    categorieId: train.categorieId,
    IsPaid: train.IsPaid,
    price: train.price,
    Participants: train.Participants,
    CoverImages: images,
    Duration: train.Duration,
    ProfesseurName: train.ProfesseurName,
    IsPart: train.IsPart, IsPublic: train.IsPublic,
  );

  factory TrainingModel.fromJson(Map<String, dynamic> json,{bool isDecode = false}) {
    return TrainingModel(
      isOnline: json['isOnline']??false,
      googleMeetLink: json['googleMeetLink']??"",
      id: json['id'] ?? "", // Use _id if id is null
      name: json['name']??"",
      description: json['description']??"",
      ActivityBeginDate: json['ActivityBeginDate'] != null ? DateTime.parse(json['ActivityBeginDate']) : DateTime.parse(json['ActivityBegindate']),
      ActivityEndDate: json['ActivityEndDate'] != null ? DateTime.parse(json['ActivityEndDate']) : DateTime.parse(json['ActivityEnddate']),
      ActivityAdress: json['ActivityAdress'] ?? "",
      ActivityPoints: json['ActivityPoints'],
      categorieId: (json['categorieId'] as List<dynamic>).map((e) => e as String).toList(),
      IsPaid: json['IsPaid'],
      price: json['price']??0,
      Participants: json['Participants'] != null ? (json['Participants'] as List<dynamic>).map( (e)=>e.toString()).toList() : [],
      CoverImages: json['CoverImages'] != null ? (json['CoverImages'] as List<dynamic>).map((e) => e as String).toList() : (json['coverImages'] as List<dynamic>).map((e) => e as String).toList(),
      Duration: json['Duration'] ?? 0,
      ProfesseurName: json['ProfesseurName']??'',
      IsPart: json['IsPart'], IsPublic: json['IsPublic'],
    );
  }
   TrainingModel fromActivity(Activity acr){
    return TrainingModel(
      isOnline: acr.isOnline,
      googleMeetLink: acr.googleMeetLink,
      id: acr.id,
      name: acr.name,
      description: acr.description,
      ActivityBeginDate: acr.ActivityBeginDate,
      ActivityEndDate: acr.ActivityEndDate,
      ActivityAdress: acr.ActivityAdress,
      ActivityPoints: acr.ActivityPoints,
      categorieId: acr.categorieId,
      IsPaid: acr.IsPaid,
      price: acr.price,
      Participants: acr.Participants,
      CoverImages: acr.CoverImages,
      Duration: this.Duration,
      ProfesseurName: ProfesseurName,
      IsPart: acr.IsPart, IsPublic: acr.IsPublic,
    );
  }
  Map<String, dynamic> toJson({bool isDecode=false}) => _$TrainingModelToJson(this);
TrainingModel copywith(List<String>parts){
  return TrainingModel(

    isOnline: isOnline,
    googleMeetLink: googleMeetLink,
    id: id,
    name: name,
    description: description,
    ActivityBeginDate: ActivityBeginDate,
    ActivityEndDate: ActivityEndDate,
    ActivityAdress: ActivityAdress,
    ActivityPoints: ActivityPoints,
    categorieId: categorieId,
    IsPaid: this.IsPaid,
    price: price,
    Participants: parts,
    CoverImages: CoverImages,
    Duration: this.Duration,
    ProfesseurName: ProfesseurName,
    IsPart: IsPart, IsPublic: this.IsPublic,
  );
}

}
