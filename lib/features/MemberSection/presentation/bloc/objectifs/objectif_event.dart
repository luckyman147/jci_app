part of 'objectif_bloc.dart';

sealed class ObjectifEvent extends Equatable {
  const ObjectifEvent();
}
class CreateObjectifEvent extends ObjectifEvent {
  final Objectif objectif;

  CreateObjectifEvent({required this.objectif});
  @override
  // TODO: implement props
  List<Object?> get props => [objectif];
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

  LoadObjectifs({required this.userId, this.lastDocument});

  @override
  // TODO: implement props
  List<Object?> get props => [userId, lastDocument];

}

class LoadMoreObjectifs extends ObjectifEvent {
  final String userId;
  final DocumentSnapshot? lastDocument;

  LoadMoreObjectifs({required this.userId, required this.lastDocument});

  @override
  List<Object> get props => [userId,];
}