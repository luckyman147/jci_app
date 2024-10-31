part of 'notes_bloc.dart';

sealed class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}
final class Notesfetched extends NotesEvent {
  final String activityId;
  final bool isUpdated;
  const Notesfetched({required this.activityId, required this.isUpdated});
  @override
  List<Object> get props => [activityId, isUpdated];
}
final class createNoteEvent extends NotesEvent {
  final NoteInput note;
  const createNoteEvent({required this.note});
  @override
  List<Object> get props => [note];
}
final class resetNotes extends NotesEvent {
  @override
  List<Object> get props => [];
}
final class updateNote extends NotesEvent {
  final Note note;
  const updateNote({required this.note});
  @override
  List<Object> get props => [note];
}
final class deleteNote extends NotesEvent {
  final NoteInput note;
  const deleteNote({required this.note});
  @override
  List<Object> get props => [note];
}
final class ArchiveEvent extends NotesEvent {
  final Note note;
  const ArchiveEvent({required this.note});
  @override
  List<Object> get props => [note ];
}
class changeNoteActionEvent extends NotesEvent {
  final NotesAction action;
   final String noteId;

  const changeNoteActionEvent(this.noteId, {required this.action, });
  @override
  List<Object> get props => [action,noteId];
}
