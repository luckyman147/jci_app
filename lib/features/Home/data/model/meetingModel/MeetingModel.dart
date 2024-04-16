import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/Meeting.dart';

part 'MeetingModel.g.dart';
@JsonSerializable()
class MeetingModel extends Meeting{

  MeetingModel({required super.id,  required super.name, required super.description,
    required super.ActivityBeginDate, required super.ActivityEndDate, required super.ActivityAdress, required super.ActivityPoints,
    required super.categorie, required super.IsPaid, required super.price, required super.Participants, required super.CoverImages,
    required super.Director, required super.agenda, required super.IsPart,  });


  factory MeetingModel.fromEntities(Meeting meeting){
    return MeetingModel(
      id:meeting.id,
      name: meeting.name,
      description: meeting.description,
      ActivityBeginDate: meeting.ActivityBeginDate,
      ActivityEndDate: meeting.ActivityEndDate,
      ActivityAdress: meeting.ActivityAdress,
      ActivityPoints: meeting.ActivityPoints,
      categorie: meeting.categorie,
      IsPaid: meeting.IsPaid,
      price: meeting.price,
      Participants: meeting.Participants,
      CoverImages: meeting.CoverImages,
      Director: meeting.Director,
      agenda: meeting.agenda,
      IsPart: meeting.IsPart,
    );
  }

factory MeetingModel.fromJson(Map<String, dynamic> json) {
    return  MeetingModel(
      id: json['id'] ?? json['_id'], // Use _id if id is null
      name: json['name'] as String,
      description: json['description'] as String,
      ActivityBeginDate: json['ActivityBeginDate'] != null ? DateTime.parse(json['ActivityBeginDate']) : DateTime.parse(json['ActivityBegindate']),
      ActivityEndDate: json['ActivityEndDate'] != null ? DateTime.parse(json['ActivityEndDate']) : json['ActivityEnddate']!=null? DateTime.parse(json['ActivityEnddate']):   DateTime.now(),
      ActivityAdress: "Local Menchia Hammem Sousse",
      ActivityPoints: json['ActivityPoints'] as int,
      categorie: json['categorie'] as String,
      IsPaid: false,
      price:0,
      Participants: json['Participants'] != null ? (json['Participants'] as List<dynamic>).map((e) => e as String).toList() :(json['participants'] as List<dynamic>).toList(),

      CoverImages: [],
      Director: json['Director'],
      agenda: json['agenda'] != null?
      (json['agenda'] as List<dynamic>).map((e) => e as String).toList():(json['Agenda'] as List<dynamic>).map((e) => e as String).toList(),
      IsPart: json['IsPart'] as bool,
    )..tempPart = false;
}
  Map<String, dynamic> toJson() => _$MeetingModelToJson(this);
}
