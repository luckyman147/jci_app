import '../../domain/entities/Event.dart';

class EventOftheWeekModel extends EventOfTheWeek {
  EventOftheWeekModel({
    required String id,
    required String name,
    required DateTime ActivityBeginDate,
    required DateTime ActivityEndDate,
    required String ActivityAdress,
    required String LeaderName,
    required List<String> Participants,
    required List<String> CoverImages,
  }) : super(
    id: id,
    name: name,
    ActivityBeginDate: ActivityBeginDate,
    ActivityEndDate: ActivityEndDate,
    ActivityAdress: ActivityAdress,
    LeaderName: LeaderName,
    Participants: Participants,
    CoverImages: CoverImages,
  );

  factory EventOftheWeekModel.fromJson(Map<String, dynamic> json) {
    return EventOftheWeekModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      ActivityBeginDate: DateTime.parse(json['ActivityBegindate'] as String),
      ActivityEndDate: DateTime.parse(json['ActivityEnddate'] as String),
      ActivityAdress: json['ActivityAdress'] as String,
      LeaderName: json['LeaderName'] as String,
      Participants: List<String>.from(json['participants'] as List),
      CoverImages: List<String>.from(json['CoverImages'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'ActivityBegindate': ActivityBeginDate.toIso8601String(),
      'ActivityEnddate': ActivityEndDate.toIso8601String(),
      'ActivityAdress': ActivityAdress,
      'LeaderName': LeaderName,
      'participants': Participants,
      'CoverImages': CoverImages,
    };
  }
}
