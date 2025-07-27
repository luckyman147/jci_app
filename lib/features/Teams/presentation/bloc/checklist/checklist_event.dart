part of 'checklist_bloc.dart';

sealed class ChecklistEvent extends Equatable {
  const ChecklistEvent();
}

class AddChecklistEvent extends ChecklistEvent {
  final String teamId;
  final String taskId;
  final String name;
  AddChecklistEvent(this.teamId, this.taskId, this.name);

  @override
  List<Object?> get props => [teamId, taskId, name];
}

class UpdateChecklistStatusEvent extends ChecklistEvent {
  final String teamId;
  final String taskId;
  final String checkId;
  final bool isCompleted;
  UpdateChecklistStatusEvent(this.teamId, this.taskId, this.checkId, this.isCompleted);
  @override
  List<Object?> get props => [teamId, taskId, checkId, isCompleted];
}

class UpdateChecklistNameEvent extends ChecklistEvent {
final ChecklistParams checklistParams;
  UpdateChecklistNameEvent( this.checklistParams);
  @override
  List<Object?> get props => [checklistParams];
}

class DeleteChecklistEvent extends ChecklistEvent {
  final String teamId;
  final String taskId;
  final String checkId;
  DeleteChecklistEvent(this.teamId, this.taskId, this.checkId);
  @override
  List<Object?> get props => [teamId, taskId, checkId];
}

class FetchChecklistsEvent extends ChecklistEvent {
  final String teamId;
  final String taskId;
  FetchChecklistsEvent(this.teamId, this.taskId);
  @override
  List<Object?> get props => [teamId, taskId];
}