

import 'package:jci_app/features/Home/domain/entities/Activity.dart';

class Event  extends Activity{

  final String LeaderName;
  final DateTime registrationDeadline;



  Event( {required this.registrationDeadline,   required this.LeaderName,

      required super.name, required super.description, required super.ActivityBeginDate,
    required super.ActivityEndDate, required super.ActivityAdress, required super.ActivityPoints, required super.categorie,
    required super.IsPaid, required super.price, required super.Participants, required super.CoverImages, required super.id, required super.IsPart, });
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
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
   @override
   // TODO: implement props
   List<Object?> get props => [LeaderName, registrationDeadline, name,
     description, ActivityBeginDate, ActivityEndDate, ActivityAdress,
     ActivityPoints, categorie, IsPaid, price, Participants, CoverImages, id, IsPart];

}
