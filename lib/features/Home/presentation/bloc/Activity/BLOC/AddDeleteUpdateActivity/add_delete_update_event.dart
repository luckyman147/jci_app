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
  final activity act;

  final Activity active;
  const UpdateActivityEvent({required this.act,required this.active});

  @override
  List<Object> get props => [act,active];
}
class DeleteActivityEvent extends AddDeleteUpdateEvent {
  final activity act;

  final String id;
  const DeleteActivityEvent({required this.act,required this.id});

  @override
  List<Object> get props => [act,id];}