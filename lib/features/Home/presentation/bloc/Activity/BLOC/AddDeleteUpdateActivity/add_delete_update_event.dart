part of 'add_delete_update_bloc.dart';

abstract class AddDeleteUpdateEvent extends Equatable {
  const AddDeleteUpdateEvent();
}

class AddACtivityEvent extends AddDeleteUpdateEvent {
  final activityParams params;

  const AddACtivityEvent({required  this.params});

  @override
  List<Object> get props => [params];
}


class UpdateActivityEvent extends AddDeleteUpdateEvent {
final activityParams params;
  const UpdateActivityEvent({required this.params});

  @override
  List<Object> get props => [params];
}
class DeleteActivityEvent extends AddDeleteUpdateEvent {
  final activityParams params;
  const DeleteActivityEvent({required this.params});

  @override
  List<Object> get props => [params];}
class CheckPermissions extends AddDeleteUpdateEvent {
  final activity act;

  const CheckPermissions({required this.act,});

  @override
  List<Object> get props => [act,];}