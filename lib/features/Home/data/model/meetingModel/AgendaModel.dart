import '../../../domain/entities/Agenda.dart';

class AgendaModel extends Agenda{
  AgendaModel({required super.title, required super.endTime, super.status = "Not Started"});

  factory AgendaModel.fromJson(Map<String, dynamic> json){
    return AgendaModel(
      title: json['title'],
      endTime: json['endTime'],

      status: json['status']??'Not Started',
    );
  }
  ///toJson

  Map<String, dynamic> toJson(){
    return {
      "title": title,
      "endTime": endTime,

      "status": status,
    };
  }
  factory AgendaModel.fromEntities(Agenda agenda){
    return AgendaModel(
      title: agenda.title,
      endTime: agenda.endTime,

      status: agenda.status,
    );
  }
}