
import '../enums/AttendeceEmum.dart';

class ParticipantsParams{
  final String? partcipantImage;
  final String? partcipantName;
  final String? ActivityId;

  final String partipantId;
  final Attendance status;

  ParticipantsParams(this.ActivityId, {required this.partcipantImage, required this.partcipantName, required this.partipantId, required this.status});

}
// Categorized participants result
class CategorizedParticipants {
  final List<ParticipantsParams> allMembersListParam;
  final List<ParticipantsParams> presentListParam;
  final List<ParticipantsParams> joinedList;
  final List<ParticipantsParams> absentList;

  CategorizedParticipants({
    required this.allMembersListParam,
    required this.presentListParam,
    required this.joinedList,
    required this.absentList,
  });
}