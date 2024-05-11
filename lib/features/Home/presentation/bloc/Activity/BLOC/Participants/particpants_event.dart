part of 'particpants_bloc.dart';

abstract class ParticpantsEvent extends Equatable {
  const ParticpantsEvent();
}

class CheckAbsenceEvent extends ParticpantsEvent {
  final ParticipantsParams params;
  CheckAbsenceEvent({required this.params});
  @override
  List<Object> get props => [params];
}
class AddParticipantEvent extends ParticpantsEvent {
  final int index;
   final activityParams act;
  AddParticipantEvent( {
    required this.act,
    required this.index});
  @override
  List<Object> get props => [act,index];
}
class RemoveParticipantEvent extends ParticpantsEvent {
 final activityParams act;
  final int index;

  RemoveParticipantEvent(  {
    required this.act,
    required this.index});
  @override
  List<Object> get props => [index,act];
}
class LoadIsParttipatedList extends ParticpantsEvent {
  final String activityId;
  LoadIsParttipatedList({required this.activityId});
  @override
  List<Object> get props => [activityId];
}
class UpdateBoolValue extends ParticpantsEvent {
  final bool newValue;
  final int index;
  final List<bool> list;

  UpdateBoolValue(this.index, this.newValue, this.list);

  @override
  // TODO: implement props
  List<Object?> get props => [newValue,index];
}

class initstateList extends ParticpantsEvent {
  final List<Map<String, dynamic>> act;
  initstateList({required this.act});
  @override
  List<Object> get props => [act];
}
class initParticipantList extends ParticpantsEvent {
  final List<dynamic> act;
  initParticipantList({required this.act});
  @override
  List<Object> get props => [act];
}
class ConfirmGuestEvent extends ParticpantsEvent {
  final guestParams params;
  ConfirmGuestEvent({required this.params});
  @override
  List<Object> get props => [params];
}
class AddGuestEvent extends ParticpantsEvent {
  final guestParams params;
  AddGuestEvent({required this.params});
  @override
  List<Object> get props => [params];
}
class DeleteGuestEvent extends ParticpantsEvent {
  final guestParams params;
  DeleteGuestEvent({required this.params});
  @override
  List<Object> get props => [params];
}
class UpdateGuestEvent extends ParticpantsEvent {
  final guestParams params;
  UpdateGuestEvent({required this.params});
  @override
  List<Object> get props => [params];
}
class GetGuestsOfActivityEvent extends ParticpantsEvent {
  final String activityId;
  GetGuestsOfActivityEvent({required this.activityId});
  @override
  List<Object> get props => [activityId];
}class GetAllGuestsEvent extends ParticpantsEvent {
final bool isUpdated;
  GetAllGuestsEvent({this.isUpdated = false});

  @override
  List<Object> get props => [isUpdated];
}
class SendReminderEvent extends ParticpantsEvent {
  final String activityId;
  SendReminderEvent({required this.activityId});
  @override
  List<Object> get props => [activityId];
}
class SearchGuestByname extends ParticpantsEvent {
  final String name;
  SearchGuestByname({required this.name});
  @override
  List<Object> get props => [name];}
  class SearchGuestActByname extends ParticpantsEvent {
  final String name;
  SearchGuestActByname({required this.name});
  @override
  List<Object> get props => [name];
}class SearchMemberByname extends ParticpantsEvent {
  final String name;
  SearchMemberByname({required this.name});
  @override
  List<Object> get props => [name];
}
class AddGuestToActivityEvent extends ParticpantsEvent {
  final guestParams params;
  AddGuestToActivityEvent({required this.params});
  @override
  List<Object> get props => [params];
}