

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
