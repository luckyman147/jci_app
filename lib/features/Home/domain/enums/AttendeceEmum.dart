enum Attendance{
  Pending,Absent,
  Present,
  joined,
  Left
}
extension AttendanceExtension on String {
  Attendance toAttendance() {
    switch (this) {
      case 'Pending':
        return Attendance.Pending;
      case 'Absent':
        return Attendance.Absent;
      case 'Present':
        return Attendance.Present;
      case 'Joined':
        return Attendance.joined;
      case 'Left':
        return Attendance.Left;
      default:
        throw ArgumentError('Unknown Attendance value: $this');
    }
  }
}

