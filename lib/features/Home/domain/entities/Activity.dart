import 'package:equatable/equatable.dart';
import 'package:jci_app/features/auth/domain/entities/Member.dart';

class Activity extends Equatable{
final String id;
final   String name;

  final String description;
 final  DateTime ActivityBeginDate;
  final DateTime ActivityEndDate;
 final  String ActivityAdress;
  final int ActivityPoints;
final String  categorie;
  final bool IsPaid;
 final  int price;
  final List<dynamic>Participants;
   final List <dynamic>CoverImages;
   bool tempPart=false;
   final bool   IsPart;
    factory Activity.fromImages(Map<String, dynamic> data) {
    return Activity(
      id: data['id']??data['_id'] ,
      name: data['name']??'',
      description: data['description']??'',
      ActivityBeginDate: data['ActivityBeginDate']??DateTime.now(),
      ActivityEndDate: data['ActivityEndDate']??DateTime.now(),
      ActivityAdress: data['ActivityAdress']??'',
      ActivityPoints: data['ActivityPoints']??0,
      categorie: data['categorie']??'',
      IsPaid: data['IsPaid']??false,
      price: data['price']??0,
      Participants: data['Participants']??[],
      CoverImages: data['CoverImages'] as List<dynamic>,
      IsPart: data['IsPart']??false,
    );
}
    Activity({required this.name,
      required this.id,
     required this.IsPart,
     required this.description,
     required this.ActivityBeginDate,
     required this.ActivityEndDate,
     required this.ActivityAdress,
     required this.ActivityPoints,
     required this.categorie,
     required this.IsPaid,
     required this.price,
     required this.Participants,
     required this.CoverImages});
  @override
  // TODO: implement props
  List<Object?> get props => [name,description,ActivityBeginDate,IsPart,ActivityEndDate,ActivityAdress,ActivityPoints,categorie
   ,IsPaid,price,

   Participants,CoverImages];

}