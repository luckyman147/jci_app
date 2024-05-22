part of 'notes_bloc.dart';

enum NotesStatus { initial, success, failure,Created,Updated,Deleted,loading,FailureCRUD,IsRefreshed }
enum NotesAction { create, update, delete, archive, unarchive }

final class NotesState extends Equatable {
  final NotesStatus status;
  final List<Note> notes;
  final bool hasReachedMax;
  final NotesAction action;
  final String  noteId;

     final String message;

  const NotesState({
    this.noteId='',
    this.action=NotesAction.create,
    this.message='',
    this.status = NotesStatus.initial,
    this.notes = const <Note>[],
    this.hasReachedMax = false,
  });

  NotesState copyWith({
    NotesAction? action,
    String? message,
    NotesStatus? status,
    List<Note>? notes,
    bool? hasReachedMax,
    String? noteId,
  }) {
    return NotesState(
      noteId: noteId ?? this.noteId,
      action: action ?? this.action,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      message: message ?? this.message,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [status,noteId, notes, hasReachedMax,message,action];
}

final class NotesInitial extends NotesState {
  @override
  List<Object> get props => [];
}
