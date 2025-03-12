import 'package:jci_app/core/PrimitiveUser/UserModel.dart';
import 'package:jci_app/features/Home/Activity_Global.dart';
import 'package:jci_app/features/Home/data/model/meetingModel/AgendaModel.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/Meeting.dart';


@JsonSerializable()
class MeetingModel extends Meeting{

  MeetingModel({required super.id,  required super.name, required super.description,
    required super.ActivityBeginDate, required super.ActivityEndDate, required super.ActivityAdress, required super.ActivityPoints,
    required super.categorieId, required super.IsPaid, required super.price, required super.Participants, required super.CoverImages,
    required super.status,
    required super.CurrentIndex,
    required super.Director, required super.agenda, required super.IsPart, required super.isOnline, required super.googleMeetLink, required super.IsPublic,  });


  factory MeetingModel.fromEntities({required Meeting meeting,String? link}){
    return MeetingModel(
      CurrentIndex: meeting.CurrentIndex,
      id:meeting.id,
      name: meeting.name,
      description: meeting.description,
      ActivityBeginDate: meeting.ActivityBeginDate,
      ActivityEndDate: meeting.ActivityEndDate,
      ActivityAdress: meeting.ActivityAdress,
      ActivityPoints: meeting.ActivityPoints,
      categorieId: meeting.categorieId,
      IsPaid: meeting.IsPaid,
      price: meeting.price,

      Participants: meeting.Participants,
      CoverImages: meeting.CoverImages,
      Director: meeting.Director,
      agenda: meeting.agenda,
      IsPart: meeting.IsPart, isOnline: meeting.isOnline, googleMeetLink: meeting.googleMeetLink, IsPublic: meeting.IsPublic, status: meeting.status,

    );
  }

factory MeetingModel.fromJson(Map<String, dynamic> json, {bool isDecode = false}) {
    return  MeetingModel(
      CurrentIndex: json['CurrentIndex']??-1,
      id: json['id'] ?? json['_id'], // Use _id if id is null
      name: json['name'] as String,
      description: json['description'] as String,
      ActivityBeginDate: json['ActivityBeginDate'] != null ? DateTime.parse(json['ActivityBeginDate']) : DateTime.parse(json['ActivityBegindate']),
      ActivityEndDate: json['ActivityEndDate'] != null ? DateTime.parse(json['ActivityEndDate']) : json['ActivityEnddate']!=null? DateTime.parse(json['ActivityEnddate']):   DateTime.now(),
      ActivityAdress: "Local Menchia Hammem Sousse",
      ActivityPoints: json['ActivityPoints']??0,
      categorieId: (json['categorieId'] as List<dynamic>).map((e)=>e.toString()).toList() ,
      IsPaid: false,
      price:0,
      IsPublic: json['IsPublic']??false,
      Participants: json['Participants'] != null ? (json ['Participants'] as List<dynamic>).map( (e)=> e.toString()).toList():[],
      CoverImages: const [],
      Director: UserModel.fromJson(json['Director'] as Map<String, dynamic>, isDecode),
      agenda: json['agenda'] != null
          ? List<Map<String, dynamic>>.from(json['agenda'].map((e) => e as Map<String, dynamic>)).map((e) => AgendaModel.fromJson(e)).toList()
          : [],

      IsPart: json['IsPart'] ??false, isOnline: json['isOnline'] ?? false, googleMeetLink: json['googleMeetLink'] ?? "",
      status: json['status'] ?? "Not Started",
    )..tempPart = false;
}
  Map<String, dynamic> toJson({bool isDecode=false}){
    return {
      "id": id,
      "name": name,
      "description": description,
      "ActivityBeginDate": ActivityBeginDate.toIso8601String(),
      "ActivityEndDate": ActivityEndDate.toIso8601String(),
      "ActivityAdress": ActivityAdress,
      "ActivityPoints": ActivityPoints,
      "categorieId": categorieId,
      "IsPaid": this.IsPaid,
      "price": price,
      "CurrentIndex": CurrentIndex,
      "status": status,
      "isOnline": isOnline,
      "IsPublic": this.IsPublic,
      "googleMeetLink": googleMeetLink,
      "Participants": Participants,
      "CoverImages": CoverImages,
      "Director": UserModel.fromEntity(Director).toJson(isDecode),
      "agenda": agenda.map((e) =>AgendaModel.fromEntities (e).toJson()).toList(),
      "IsPart": IsPart,
      "type": type,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }

  MeetingModel fromActivity(Activity activitys) {
    return MeetingModel(
      id: activitys.id,
      name: activitys.name,
      CurrentIndex: CurrentIndex,
      description: activitys.description,
      ActivityBeginDate: activitys.ActivityBeginDate,
      ActivityEndDate: activitys.ActivityEndDate,
      ActivityAdress: activitys.ActivityAdress,
      ActivityPoints: activitys.ActivityPoints,
      categorieId: activitys.categorieId,
      IsPaid: activitys.IsPaid,
      price: activitys.price,
      Participants: activitys.Participants,
      CoverImages: activitys.CoverImages,
      Director: Director,
      agenda: agenda,
      status: status,
      IsPart: activitys.IsPart,
      isOnline: activitys.isOnline,
      googleMeetLink: activitys.googleMeetLink,
      IsPublic: activitys.IsPublic,
    );

  }

  MeetingModel copywith(List<String> activitiesPartcipants) {
    return MeetingModel(
      id: id,
      name: name,
      CurrentIndex: CurrentIndex,
      description: description,
      ActivityBeginDate: ActivityBeginDate,
      ActivityEndDate: ActivityEndDate,
      ActivityAdress: ActivityAdress,
      ActivityPoints: ActivityPoints,
      categorieId: categorieId,
      IsPaid: this.IsPaid,
      price: price,
      Participants: activitiesPartcipants,
      CoverImages: CoverImages,
      Director: Director,
      agenda: agenda,
      IsPart: IsPart,
      isOnline: isOnline,
      googleMeetLink: googleMeetLink,
      IsPublic:this. IsPublic, status: status,
    );
  }
}
