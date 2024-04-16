

import 'package:jci_app/features/Home/presentation/widgets/EventListWidget.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/Activity.dart';
import '../../../domain/entities/Event.dart';


part 'EventModel.g.dart';
@JsonSerializable()
class EventModel extends Event{

  EventModel({required super.id, required super.LeaderName, required super.name, required super.description,
    required super.ActivityBeginDate, required super.ActivityEndDate, required super.ActivityAdress, required super.ActivityPoints,
    required super.categorie, required super.IsPaid, required super.price, required super.Participants,
    required super.CoverImages, required super.registrationDeadline, required super.IsPart,});
// empty constructor

  factory EventModel.fromEntity( Event event){
    return EventModel(
      id:event.id,
      LeaderName: event.LeaderName,
      name: event.name,
      description: event.description,
      ActivityBeginDate: event.ActivityBeginDate,
      ActivityEndDate: event.ActivityEndDate,
      ActivityAdress: event.ActivityAdress,
      ActivityPoints: event.ActivityPoints,
      categorie: event.categorie,
      IsPaid: event.IsPaid,
      price: event.price,
      Participants: event.Participants,
      CoverImages: event.CoverImages,
      registrationDeadline: event.registrationDeadline,
      IsPart: event.IsPart,
    );
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? json['_id']??"", // Use _id if id is null
      LeaderName: json['LeaderName']??"",
      name: json['name'],
      description: json['description']??"",
      ActivityBeginDate: json['ActivityBeginDate'] != null ? DateTime.parse(json['ActivityBeginDate']) : json['ActivityBegindate']!=null? DateTime.parse(json['ActivityBegindate']): DateTime.now(),
      ActivityEndDate: json['ActivityEndDate'] != null ? DateTime.parse(json['ActivityEndDate']) : json['ActivityEnddate']!=null? DateTime.parse(json['ActivityEnddate']):   DateTime.now(),

      ActivityAdress: json['ActivityAdress']??"",
      ActivityPoints: json['ActivityPoints']??0,
      categorie: json['categorie']??"",
      IsPaid: json['IsPaid']??false,
      price: json['price']??0,
      Participants: json['Participants']?? json['participants']??[],
      CoverImages: json['CoverImages'] != null ? (json['CoverImages'] as List<dynamic>).map((e) => e as String).toList() : json['coverImages']!=null?(json['coverImages'] as List<dynamic>).map((e) => e as String).toList():[],

      registrationDeadline:json['registrationDeadline']==null ? DateTime.now() :DateTime.parse( json['registrationDeadline']) ,
      IsPart: json['IsPart']??false,
    );
  }
  Map<String, dynamic> toJson() => _$EventModelToJson(this);
}


