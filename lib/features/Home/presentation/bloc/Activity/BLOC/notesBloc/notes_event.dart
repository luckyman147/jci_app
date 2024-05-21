part of 'notes_bloc.dart';

sealed class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}
final class Notesfetched extends NotesEvent {
  final String activityId;
  final bool isUpdated;
  Notesfetched({required this.activityId, required this.isUpdated});
  @override
  List<Object> get props => [activityId, isUpdated];
}
