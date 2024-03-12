part of 'particpants_bloc.dart';

abstract class ParticpantsEvent extends Equatable {
  const ParticpantsEvent();
}

class GetParticipantsEvent extends ParticpantsEvent {
  final String id;
  GetParticipantsEvent({required this.id});
  @override
  List<Object> get props => [id];
}
class AddParticipantEvent extends ParticpantsEvent {
  final int index;
   final activity act;

  final String id;
  AddParticipantEvent( {required this.id,
    required this.act,
    required this.index});
  @override
  List<Object> get props => [id];
}
class RemoveParticipantEvent extends ParticpantsEvent {
  final activity act;
  final String id;
  final int index;

  RemoveParticipantEvent(  {required this.id ,
    required this.act,
    required this.index});
  @override
  List<Object> get props => [id];
}
class LoadIsParttipatedList extends ParticpantsEvent {
  final List<Activity> act;
  LoadIsParttipatedList({required this.act});
  @override
  List<Object> get props => [act];
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