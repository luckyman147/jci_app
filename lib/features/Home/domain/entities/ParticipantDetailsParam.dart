import 'package:jci_app/features/Home/domain/enums/AttendeceEmum.dart';


class ParticipantDetailsParam {
  final String participant;
  final Attendance attendance;

  ParticipantDetailsParam({required this.participant,  this.attendance=Attendance.Pending});
factory ParticipantDetailsParam.fromMap(Map<String, dynamic> data,{bool isDecode = false}) {
    return ParticipantDetailsParam(
      participant: data["memberId"]??'',
      attendance: toAttendance(data["attendance"]??''),
    );
  }
  //f rom map
// to attendance


  Map<String, dynamic> toMap({bool isDecode = false}) {
    return {
      'participant': participant,
      'attendance': attendance.name,
    };
  }

}  Attendance toAttendance(String attendance) {
  switch (attendance) {
    case 'Pending':
      return Attendance.Pending;
    case 'Present':
      return Attendance.Present;
    case 'Absent':
      return Attendance.Absent;
    default:
      return Attendance.joined;
  }
}