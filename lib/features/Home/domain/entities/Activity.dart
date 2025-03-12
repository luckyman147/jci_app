import 'package:equatable/equatable.dart';
import 'package:jci_app/features/Home/domain/entities/ParticipantDetailsParam.dart';

class Activity extends Equatable{
final String id;
final   String name;

  final String description;
 final  DateTime ActivityBeginDate;
  final DateTime ActivityEndDate;
 final  String ActivityAdress;
  final int ActivityPoints;
final List<String>  categorieId;
final bool isOnline;
final String googleMeetLink;
  final bool IsPaid;
 final  int price;
 final bool IsPublic;
  final List<String>Participants;
   final List <String>CoverImages;
   bool tempPart=false;
   final bool   IsPart;
   final DateTime createdAt=DateTime.now();
    final DateTime updatedAt=DateTime.now();

Type getInstanceType(Activity instance) {
  return instance.runtimeType;
}
    factory Activity.fromImages(Map<String, dynamic> data) {
    return Activity(
      id: data['id']??data['_id'] ,
      isOnline: data['isOnline']??false,
      googleMeetLink: data['googleMeetLink']??'',
      name: data['name']??'',
      description: data['description']??'',
      ActivityBeginDate: data['ActivityBeginDate']??DateTime.now(),
      ActivityEndDate: data['ActivityEndDate']??DateTime.now(),
      ActivityAdress: data['ActivityAdress']??'',
      ActivityPoints: data['ActivityPoints']??0,
      categorieId: data['categorieId']??'',
      IsPaid: data['IsPaid']??false,
      price: data['price']??0,
      Participants: data['Participants']??[],
      CoverImages: data['CoverImages'] as List<String>,
      IsPart: data['IsPart']??false, IsPublic: data['IsPublic']??false,
    );
}
    Activity({required this.name,
    required this.IsPublic,
      required this.id,
      required this.isOnline,
      required this.googleMeetLink,
     required this.IsPart,
     required this.description,
     required this.ActivityBeginDate,
     required this.ActivityEndDate,
     required this.ActivityAdress,
     required this.ActivityPoints,
     required this.categorieId,
     required this.IsPaid,
     required this.price,
     required this.Participants,
     required this.CoverImages});
  @override
  // TODO: implement props
  List<Object?> get props => [name,description,ActivityBeginDate,IsPart,ActivityEndDate,ActivityAdress,ActivityPoints,categorieId
   ,IsPaid,price,IsPublic,

   Participants,CoverImages];
Activity get ActivityTest=>Activity(name: "", id: "id", description: "description",
    ActivityBeginDate: DateTime.now(), ActivityEndDate: DateTime.now(),
    ActivityAdress: "ActivityAdress",
    ActivityPoints:2, categorieId: const [], IsPaid: false,
    price: 1, Participants: const [], CoverImages: const [], IsPart: false, IsPublic: false, isOnline: false,googleMeetLink: "");

 Activity copyWith({required List<String> Participants}) {
    return Activity(
      name: name,
      id: id,
      description: description,
      ActivityBeginDate: ActivityBeginDate,
      ActivityEndDate: ActivityEndDate,
      ActivityAdress: ActivityAdress,
      ActivityPoints: ActivityPoints,
      categorieId: categorieId,
      isOnline: isOnline,
      googleMeetLink: googleMeetLink,
      IsPaid: IsPaid,
      price: price,
      IsPublic: IsPublic,
      Participants: Participants,
      CoverImages: CoverImages,
      IsPart: IsPart,
    );
  }


}