part of 'objectif_bloc.dart';

sealed class ObjectifEvent extends Equatable {
  const ObjectifEvent();
}

class UpdateUserObjectiveProgressEvent extends ObjectifEvent{
  final UpdateObjectiveProgressDTO updateObjectiveProgressDTO;

  UpdateUserObjectiveProgressEvent({required this.updateObjectiveProgressDTO});

  @override
  // TODO: implement props
  List<Object?> get props =>   [updateObjectiveProgressDTO];
}
class RemoveFirstIndexEvent extends ObjectifEvent{


  @override
  // TODO: implement props
  List<Object?> get props =>   [];
}


class DeleteObjectifEvent extends ObjectifEvent {
  final String objectifId;

  DeleteObjectifEvent({required this.objectifId});

  @override
  List<Object?> get props => [objectifId];}

class CreateObjectifEvent extends ObjectifEvent {
  final Objectif objectif;

  CreateObjectifEvent({required this.objectif});
  @override
  // TODO: implement props
  List<Object?> get props => [objectif];
}
class SetEvent extends ObjectifEvent {
  final ObjectiveEvent event;

  SetEvent({required this.event});

  @override
  List get props => [event];}
class EditObjectifEvent extends ObjectifEvent {
  final Objectif objectif;

  EditObjectifEvent({required this.objectif});
  @override
  List<Object?> get props => [objectif];}
class GroupByEvent extends ObjectifEvent {
  final String? groupBy;

  GroupByEvent({required this.groupBy});

  @override
  // TODO: implement props
  List<Object?> get props => [groupBy];


}
class ChangeStatus extends ObjectifEvent{
  final ObjectifStatus status;

  ChangeStatus({required this.status});
  @override
  // TODO: implement props
  List<Object?> get props => [status];

}
class LoadObjectifs extends ObjectifEvent {
  final String userId;
  final DocumentSnapshot? lastDocument;
  final bool isRefreshed;

  LoadObjectifs({required this.userId, this.lastDocument, this.isRefreshed = false});

  @override
  // TODO: implement props
  List<Object?> get props => [userId, lastDocument,isRefreshed];

}

class LoadMoreObjectifs extends ObjectifEvent {
  final String userId;
  final DocumentSnapshot? lastDocument;

  LoadMoreObjectifs({required this.userId, required this.lastDocument});

  @override
  List<Object> get props => [userId,];
}