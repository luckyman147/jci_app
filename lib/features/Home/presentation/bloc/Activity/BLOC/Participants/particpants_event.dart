part of 'particpants_bloc.dart';

abstract class ParticpantsEvent extends Equatable {
  const ParticpantsEvent();
}

class CheckAbsenceEvent extends ParticpantsEvent {
  final ParticipantsParams params;
  const CheckAbsenceEvent({required this.params});
  @override
  List<Object> get props => [params];
}
class ChangeGuestToMemberEvent extends ParticpantsEvent {
  final String params;
  const ChangeGuestToMemberEvent({required this.params});
  @override
  List<Object> get props => [params];
}
class AddParticipantEvent extends ParticpantsEvent {
  final int index;
   final activityParams act;
  const AddParticipantEvent( {
    required this.act,
    required this.index});
  @override
  List<Object> get props => [act,index];
}
class RemoveParticipantEvent extends ParticpantsEvent {
 final activityParams act;
  final int index;

  const RemoveParticipantEvent(  {
    required this.act,
    required this.index});
  @override
  List<Object> get props => [index,act];
}
class LoadIsParttipatedList extends ParticpantsEvent {
  final String activityId;
  const LoadIsParttipatedList({required this.activityId});
  @override
  List<Object> get props => [activityId];
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
class ConfirmGuestEvent extends ParticpantsEvent {
  final guestParams params;
  const ConfirmGuestEvent({required this.params});
  @override
  List<Object> get props => [params];
}
class AddGuestEvent extends ParticpantsEvent {
  final guestParams params;
  const AddGuestEvent({required this.params});
  @override
  List<Object> get props => [params];
}
class DeleteGuestEvent extends ParticpantsEvent {
  final guestParams params;
  const DeleteGuestEvent({required this.params});
  @override
  List<Object> get props => [params];
}
class UpdateGuestEvent extends ParticpantsEvent {
  final guestParams params;
  const UpdateGuestEvent({required this.params});
  @override
  List<Object> get props => [params];
}
class GetGuestsOfActivityEvent extends ParticpantsEvent {
  final String activityId;
  const GetGuestsOfActivityEvent({required this.activityId});
  @override
  List<Object> get props => [activityId];
}class GetAllGuestsEvent extends ParticpantsEvent {
final bool isUpdated;
  const GetAllGuestsEvent({this.isUpdated = false});

  @override
  List<Object> get props => [isUpdated];
}
class SendReminderEvent extends ParticpantsEvent {
  final String activityId;
  const SendReminderEvent({required this.activityId});
  @override
  List<Object> get props => [activityId];
}
class SearchGuestByname extends ParticpantsEvent {
  final String name;
  const SearchGuestByname({required this.name});
  @override
  List<Object> get props => [name];}
  class SearchGuestActByname extends ParticpantsEvent {
  final String name;
  const SearchGuestActByname({required this.name});
  @override
  List<Object> get props => [name];
}class SearchMemberByname extends ParticpantsEvent {
  final String name;
  const SearchMemberByname({required this.name});
  @override
  List<Object> get props => [name];
}
class AddGuestToActivityEvent extends ParticpantsEvent {
  final guestParams params;
  const AddGuestToActivityEvent({required this.params});
  @override
  List<Object> get props => [params];
}
class DownloadAndSaveExcelEvent extends ParticpantsEvent {
  final String activityId;
  const DownloadAndSaveExcelEvent({required this.activityId});
  @override
  List<Object> get props => [activityId];
}