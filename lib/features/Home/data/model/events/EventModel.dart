

import 'package:jci_app/core/PrimitiveUser/UserModel.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/Activity.dart';
import '../../../domain/entities/Event.dart';


part 'EventModel.g.dart';
@JsonSerializable()
class EventModel extends Event{

  EventModel({required super.id, required super.LeaderName, required super.name, required super.description,
    required super.ActivityBeginDate, required super.ActivityEndDate, required super.ActivityAdress, required super.ActivityPoints,
    required super.categorieId, required super.IsPaid, required super.price, required super.Participants,
    required super.CoverImages, required super.registrationDeadline, required super.IsPart, required super.IsPublic, required super.isOnline, required super.googleMeetLink,});
// empty constructor

  factory EventModel.fromEntity( {required Event event,String? link}){
    return EventModel(
      isOnline: event.isOnline,
      googleMeetLink: link??"",
      id:event.id,
      LeaderName: event.LeaderName,
      name: event.name,
      description: event.description,
      ActivityBeginDate: event.ActivityBeginDate,
      ActivityEndDate: event.ActivityEndDate,
      ActivityAdress: event.ActivityAdress,
      ActivityPoints: event.ActivityPoints,
      categorieId: event.categorieId,
      IsPaid: event.IsPaid,
      price: event.price,
      Participants: event.Participants ?? [],
      CoverImages: event.CoverImages,
      registrationDeadline: event.registrationDeadline,
      IsPart: false, IsPublic: event.IsPublic,
    );
  }

  factory EventModel.fromJson(Map<String, dynamic> json, {bool isDecode = false}) {
    return EventModel(
      isOnline: json['isOnline']??false,
      googleMeetLink: json['googleMeetLink']??"",
      id: json['id'] ?? json['_id']??"", // Use _id if id is null
      LeaderName: UserModel.fromJson(json['LeaderName'], isDecode),
      name: json['name'],
      description: json['description']??"",
      ActivityBeginDate: json['ActivityBeginDate'] != null ? DateTime.parse(json['ActivityBeginDate']) : json['ActivityBegindate']!=null? DateTime.parse(json['ActivityBegindate']): DateTime.now(),
      ActivityEndDate: json['ActivityEndDate'] != null ? DateTime.parse(json['ActivityEndDate']) : json['ActivityEnddate']!=null? DateTime.parse(json['ActivityEnddate']):   DateTime.now(),

      ActivityAdress: json['ActivityAdress']??"",
      IsPublic: json['IsPublic']??false,
      ActivityPoints: json['ActivityPoints']??0,
      categorieId: (json['categorieId'] as List<dynamic>).map((e) => e.toString()).toList(),
      IsPaid: json['IsPaid']??false,
      price: json['price']??0,
      Participants: json['Participants'] != null ? (json ['Participants'] as List<dynamic>).map((e)=>e.toString()).toList():[],
      CoverImages: json['CoverImages'] != null ? (json['CoverImages'] as List<dynamic>).map((e) => e as String).toList() : json['coverImages']!=null?(json['coverImages'] as List<dynamic>).map((e) => e as String).toList():[],

      registrationDeadline:json['registrationDeadline']==null ? DateTime.now() :DateTime.parse( json['registrationDeadline']) ,
      IsPart: json['IsPart']??false,
    );
  }
  //set Images
factory EventModel.setImages({required EventModel event,required List<String> images}){
  return EventModel(
    isOnline: event.isOnline,
    googleMeetLink: event.googleMeetLink,
    id:event.id,
    LeaderName: event.LeaderName,
    name: event.name,
    description: event.description,
    ActivityBeginDate: event.ActivityBeginDate,
    ActivityEndDate: event.ActivityEndDate,
    ActivityAdress: event.ActivityAdress,
    ActivityPoints: event.ActivityPoints,
    categorieId: event.categorieId,
    IsPaid: event.IsPaid,
    price: event.price,
    Participants: event.Participants,
    CoverImages: images,
    registrationDeadline: event.registrationDeadline,
    IsPart: event.IsPart,
    IsPublic: event.IsPublic,
  );
}
  //set Participants
  factory EventModel.setParticipants({required EventModel event,required List<String> participants}){
    return EventModel(
      isOnline: event.isOnline,
      googleMeetLink: event.googleMeetLink,
      id:event.id,
      LeaderName: event.LeaderName,
      name: event.name,
      description: event.description,
      ActivityBeginDate: event.ActivityBeginDate,
      ActivityEndDate: event.ActivityEndDate,
      ActivityAdress: event.ActivityAdress,
      ActivityPoints: event.ActivityPoints,
      categorieId: event.categorieId,
      IsPaid: event.IsPaid,
      price: event.price,
      Participants: participants,
      CoverImages: event.CoverImages,
      registrationDeadline: event.registrationDeadline,
      IsPart: event.IsPart,
      IsPublic: event.IsPublic,
    );
  }
  //set isPart
  factory EventModel.setIsPart({required EventModel event,required List<String> images}){
    return EventModel(
      isOnline: event.isOnline,
      googleMeetLink: event.googleMeetLink,
      id:event.id,
      LeaderName: event.LeaderName,
      name: event.name,
      description: event.description,
      ActivityBeginDate: event.ActivityBeginDate,
      ActivityEndDate: event.ActivityEndDate,
      ActivityAdress: event.ActivityAdress,
      ActivityPoints: event.ActivityPoints,
      categorieId: event.categorieId,
      IsPaid: event.IsPaid,
      price: event.price,
      Participants: event.Participants,
      CoverImages: images,
      registrationDeadline: event.registrationDeadline,
      IsPart: event.IsPart,
      IsPublic: event.IsPublic,
    );
}


  Map<String, dynamic> toJson({bool isdecode=false}) => _$EventModelToJson(this,isDecode: isdecode);

  EventModel fromActivity(Activity activitys) {
    return EventModel(
      id: activitys.id,
      LeaderName: LeaderName,
      name: activitys.name,
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
      registrationDeadline: registrationDeadline,
      IsPart: activitys.IsPart,
      IsPublic: activitys.IsPublic,
      isOnline: activitys.isOnline,
      googleMeetLink: activitys.googleMeetLink,
    );
  }

  EventModel copywith(List<String> activitiesPartcipants) {
    return EventModel(

      isOnline: isOnline,
      googleMeetLink: googleMeetLink,
      id: id,
      LeaderName: LeaderName,
      name: name,
      description: description,
      ActivityBeginDate: ActivityBeginDate,
      ActivityEndDate: ActivityEndDate,
      ActivityAdress: ActivityAdress,
      ActivityPoints: ActivityPoints,
      categorieId: categorieId,
      IsPaid: IsPaid,
      price: price,
      Participants: activitiesPartcipants,
      CoverImages: CoverImages,
      registrationDeadline: registrationDeadline,
      IsPart: IsPart,
      IsPublic: IsPublic,
    );
  }
}


