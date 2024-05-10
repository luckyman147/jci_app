import 'package:jci_app/features/Home/domain/entities/Activity.dart';

class ActivityModel extends Activity{
  ActivityModel({required super.name, required super.id, required super.IsPart, required super.description, required super.ActivityBeginDate, required super.ActivityEndDate, required super.ActivityAdress, required super.ActivityPoints, required super.categorie, required super.IsPaid, required super.price, required super.Participants, required super.CoverImages});
  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      name: json['name'],
      id: json['id']??json['_id'],
      IsPart: json['IsPart']??false,
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

    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'IsPart': IsPart,
      'description': description,
      'ActivityBeginDate': ActivityBeginDate,
      'ActivityEndDate': ActivityEndDate,
      'ActivityAdress': ActivityAdress,
      'ActivityPoints': ActivityPoints,
      'categorie': categorie,
      'IsPaid': IsPaid,
      'price': price,
      'Participants': Participants,
      'CoverImages': CoverImages,
    };
  }


}