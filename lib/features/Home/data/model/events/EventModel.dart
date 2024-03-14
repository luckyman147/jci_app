

import 'package:jci_app/features/Home/presentation/widgets/EventListWidget.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/Event.dart';


part 'EventModel.g.dart';
@JsonSerializable()
class EventModel extends Event{

  EventModel({required super.id, required super.LeaderName, required super.name, required super.description,
    required super.ActivityBeginDate, required super.ActivityEndDate, required super.ActivityAdress, required super.ActivityPoints,
    required super.categorie, required super.IsPaid, required super.price, required super.Participants,
    required super.CoverImages, required super.registrationDeadline, required super.IsPart,});

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? json['_id'], // Use _id if id is null
      LeaderName: json['LeaderName'],
      name: json['name'],
      description: json['description'],
      ActivityBeginDate: json['ActivityBeginDate'] != null ? DateTime.parse(json['ActivityBeginDate']) : DateTime.parse(json['ActivityBegindate']),
      ActivityEndDate: json['ActivityEndDate'] != null ? DateTime.parse(json['ActivityEndDate']) : json['ActivityEnddate']!=null? DateTime.parse(json['ActivityEnddate']):   DateTime.now(),

      ActivityAdress: json['ActivityAdress'],
      ActivityPoints: json['ActivityPoints'],
      categorie: json['categorie'],
      IsPaid: json['IsPaid'],
      price: json['price'],
      Participants: json['Participants']?? json['participants'],
      CoverImages: json['CoverImages'] != null ? (json['CoverImages'] as List<dynamic>).map((e) => e as String).toList() : (json['coverImages'] as List<dynamic>).map((e) => e as String).toList(),

      registrationDeadline:DateTime.parse( json['registrationDeadline']),
      IsPart: json['IsPart'],
    );
  }
  Map<String, dynamic> toJson() => _$EventModelToJson(this);
}


