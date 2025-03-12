

import 'package:jci_app/features/Home/domain/entities/Activity.dart';

import '../../../../core/PrimitiveUser/User.dart';

class Event  extends Activity{

  final User LeaderName;
  final DateTime registrationDeadline;
  final type="Event";

   static Event get EventTest=>Event(registrationDeadline: DateTime.now(), LeaderName: User.UserTest(), name: "Choose the Event",
      description: "hola", ActivityBeginDate: DateTime.now(), ActivityEndDate: DateTime.now(), ActivityAdress: "hhhh",
      ActivityPoints: 2, categorieId: const [], IsPaid: false, price: 0, Participants: const [], CoverImages: const [], id: '', IsPart: false, IsPublic: false, isOnline: false,googleMeetLink: "");

  Event( {required this.registrationDeadline,   required this.LeaderName,

      required super.name, required super.description, required super.ActivityBeginDate,
    required super.ActivityEndDate, required super.ActivityAdress, required super.ActivityPoints, required super.categorieId,
    required super.IsPaid, required super.price, required super.Participants, required super.CoverImages, required super.id, required super.IsPart, required super.IsPublic, required super.isOnline, required super.googleMeetLink, });
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      isOnline: json['isOnline']??false,
      googleMeetLink: json['googleMeetLink']??"",
      id: json['id'] ?? json['_id']??"", // Use _id if id is null
      LeaderName: json['LeaderName']??"",
      name: json['name'],
      description: json['description']??"",
      ActivityBeginDate: json['ActivityBeginDate'] != null ? DateTime.parse(json['ActivityBeginDate']) : json['ActivityBegindate']!=null? DateTime.parse(json['ActivityBegindate']): DateTime.now(),
      ActivityEndDate: json['ActivityEndDate'] != null ? DateTime.parse(json['ActivityEndDate']) : json['ActivityEnddate']!=null? DateTime.parse(json['ActivityEnddate']):   DateTime.now(),

      ActivityAdress: json['ActivityAdress']??"",
      ActivityPoints: json['ActivityPoints']??0,
      categorieId: json['categorieId']??"",
      IsPaid: json['IsPaid']??false,
      price: json['price']??0,
      Participants: json['Participants']?? json['participants']??[],
      CoverImages: json['CoverImages'] != null ? (json['CoverImages'] as List<dynamic>).map((e) => e as String).toList() : json['coverImages']!=null?(json['coverImages'] as List<dynamic>).map((e) => e as String).toList():[],

      registrationDeadline:json['registrationDeadline']==null ? DateTime.now() :DateTime.parse( json['registrationDeadline']) ,
      IsPart: json['IsPart']??false, IsPublic: json['IsPublic']??false,
    );
  }
   @override
   // TODO: implement props
   List<Object?> get props => [LeaderName, registrationDeadline, name,
     description, ActivityBeginDate, ActivityEndDate, ActivityAdress,
     isOnline, googleMeetLink,
     ActivityPoints, categorieId, IsPaid, price, Participants, CoverImages, id, IsPart, IsPublic];

}
