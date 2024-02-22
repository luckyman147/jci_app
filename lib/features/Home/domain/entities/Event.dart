

class Event {
  final String id;
  final String LeaderName;
  final String name;

final DateTime ActivityBeginDate;
  final DateTime ActivityEndDate;
  final List<dynamic> Participants;
  final List<String?> CoverImages;
final String ActivityAdress;
  Event( {
    required this.id,
    required this.name,
    required this.ActivityBeginDate,
    required this.ActivityEndDate,
    required this.ActivityAdress,

required this.LeaderName,

    required this.Participants, required this.CoverImages, });

   @override
   // TODO: implement props
   List<Object?> get props => [name,ActivityBeginDate,
     ActivityEndDate,ActivityAdress,

     Participants,CoverImages,LeaderName];

}
class EventOfTheWeek extends Event{
  EventOfTheWeek({required super.id, required super.name, required super.ActivityBeginDate, required super.ActivityEndDate, required super.ActivityAdress, required super.LeaderName, required super.Participants, required super.CoverImages});

  @override
  // TODO: implement props
  List<Object?> get props => [name,ActivityBeginDate,
    ActivityEndDate,ActivityAdress,

    Participants,CoverImages,LeaderName];
}
class EventOfTheMonth extends Event {
  EventOfTheMonth(
      {required super.id, required super.name, required super.ActivityBeginDate, required super.ActivityEndDate, required super.ActivityAdress, required super.LeaderName, required super.Participants, required super.CoverImages});


  @override
  // TODO: implement props
  List<Object?> get props =>
      [name, ActivityBeginDate,
        ActivityEndDate, ActivityAdress,

        Participants, CoverImages, LeaderName];

}