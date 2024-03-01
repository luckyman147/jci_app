part of 'add_delete_update_bloc.dart';

abstract class AddDeleteUpdateEvent extends Equatable {
  const AddDeleteUpdateEvent();
}

class AddACtivityEvent extends AddDeleteUpdateEvent {
  final Activity act;
  final activity type;

  AddACtivityEvent({required this.act, required this.type});

  @override
  List<Object> get props => [act];
}



class UpdateActivityEvent extends AddDeleteUpdateEvent {
  final Activity act;
  final activity type;

  UpdateActivityEvent(this.type, {required this.act});

  @override
  List<Object> get props => [act];
}

class DeleteActivityEvent extends AddDeleteUpdateEvent {
  final String actId;

  DeleteActivityEvent({required this.actId});

  @override
  List<Object> get props => [actId];
}
