import 'package:equatable/equatable.dart';
import 'package:jci_app/features/auth/domain/entities/LoginMember.dart';

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
   final List <String?>CoverImages;
    Activity({required this.name,
      required this.id,
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
  List<Object?> get props => [name,description,ActivityBeginDate,ActivityEndDate,ActivityAdress,ActivityPoints,categorie,IsPaid,price,Participants,CoverImages];

}