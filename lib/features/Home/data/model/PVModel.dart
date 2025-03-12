import 'package:jci_app/features/Home/domain/entities/PVEntity/PV.dart';

class PvModel extends PV{
  PvModel({required super.title, required super.date, required super.link, required super.Extension,super.id});

  factory PvModel.fromModel(PvModel pv) {
    return PvModel(
      title: pv.title,

      date: pv.date,
      link: pv.link,
      Extension: pv.Extension,
    );
  }
  factory PvModel.fromEntity(PV pv) {
    return PvModel(
      title: pv.title,

      date: pv.date,
      link: pv.link,
      Extension: pv.Extension,
    );
  }
  factory PvModel.fromMap(Map<String, dynamic> map) {
    return PvModel(

      id: map['id']??"",
      title: map['title'],

      date: DateTime.parse(map['date']),
      link: map['link'],
      Extension: map['Extension'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,

      'date': date.toIso8601String(),
      'link': link,
      'Extension': Extension,
    };
  }
  // Set Link





  // Set All



}