part of 'notes_bloc.dart';

enum NotesStatus { initial, success, failure,Created,Updated,Deleted,loading }


final class NotesState extends Equatable {
  final NotesStatus status;
  final List<Note> notes;
  final bool hasReachedMax;
   final String message;

  const NotesState({
    this.message='',
    this.status = NotesStatus.initial,
    this.notes = const <Note>[],
    this.hasReachedMax = false,
  });

  NotesState copyWith({
    String? message,
    NotesStatus? status,
    List<Note>? notes,
    bool? hasReachedMax,
  }) {
    return NotesState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      message: message ?? this.message,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [status, notes, hasReachedMax,message];
}

final class NotesInitial extends NotesState {
  @override
  List<Object> get props => [];
}
