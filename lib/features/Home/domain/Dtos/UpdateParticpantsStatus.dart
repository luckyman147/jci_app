import '../entities/ParticipantDetailsParam.dart';

class UpdateMembersAttendanceParams {
  final String ActivityId;
  final List<ParticipantDetailsParam> members;

  UpdateMembersAttendanceParams({required this.ActivityId, required this.members});
}