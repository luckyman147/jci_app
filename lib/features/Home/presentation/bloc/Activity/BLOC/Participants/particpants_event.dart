
part of 'particpants_bloc.dart';

abstract class ParticpantsEvent extends Equatable {
  const ParticpantsEvent();
}
class ChangeSelectAll extends ParticpantsEvent {
  final bool value;
  const ChangeSelectAll({required this.value});
  @override
  List<Object> get props => [value];
}
class CheckAbsenceEvent extends ParticpantsEvent {
  final ParticipantsParams params;
  const CheckAbsenceEvent({required this.params});
  @override
  List<Object> get props => [params];
}
class SelectPartcipantsEvent extends ParticpantsEvent {
  final ParticipantsParams? params;
  final List<ParticipantsParams>? participants;
  const SelectPartcipantsEvent(this.participants, {required this.params});
  @override
  List<Object> get props => [];
}
class UpdateParticpantsStatusEvent extends ParticpantsEvent {
  final UpdateMembersAttendanceParams params;
  const UpdateParticpantsStatusEvent({required this.params});
  @override
  List<Object> get props => [params];
}

class LoadIsParttipatedList extends ParticpantsEvent {
  final String activityId;
  final List<String> participants;
  const LoadIsParttipatedList(this.participants, {required this.activityId});
  @override
  List<Object> get props => [activityId, participants];
}
class UpdateBoolValue extends ParticpantsEvent {
  final bool newValue;
  final int index;
  final List<bool> list;

  const UpdateBoolValue(this.index, this.newValue, this.list);

  @override
  // TODO: implement props
  List<Object?> get props => [newValue,index];
}

class initstateList extends ParticpantsEvent {
  final List<Map<String, dynamic>> act;
  const initstateList({required this.act});
  @override
  List<Object> get props => [act];
}
class initParticipantList extends ParticpantsEvent {
  final List<dynamic> act;
  const initParticipantList({required this.act});
  @override
  List<Object> get props => [act];
}
class SendReminderEvent extends ParticpantsEvent {
  final ReminderParams reminderParams;
  const SendReminderEvent({required this.reminderParams});
  @override
  List<Object> get props => [reminderParams];
}
class SearchMemberByname extends ParticpantsEvent {
  final String name;
  const SearchMemberByname({required this.name});
  @override
  List<Object> get props => [name];
}

class DownloadAndSaveExcelEvent extends ParticpantsEvent {
  final String activityId;
  const DownloadAndSaveExcelEvent({required this.activityId});
  @override
  List<Object> get props => [activityId];
}
