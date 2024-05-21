import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../../domain/entities/Note.dart';
import '../../../../../domain/usercases/MeetingsUseCase.dart';

part 'notes_event.dart';
part 'notes_state.dart';
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };}
class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc(this.getAllNotesUseCase) : super(NotesInitial()) {
    on<NotesEvent>((event, emit) {

      // TODO: implement event handler
    });
    on<Notesfetched>(_onNotesFetched,  transformer: throttleDroppable(throttleDuration),);

  }
  final GetNotesOfActivityUseCase getAllNotesUseCase;
  Future<void> _onNotesFetched(Notesfetched event, Emitter<NotesState> emit) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == NotesStatus.initial || event.isUpdated) {
        emit(state.copyWith(status: NotesStatus.loading));
        final notes = await getAllNotesUseCase.call(event.activityId, event.isUpdated);
        final note= notes.getOrElse(() => []);
        return emit(state.copyWith(
          status: NotesStatus.success,
          notes: note,
          hasReachedMax: false,
        ));
      }
      emit(state.copyWith(status: NotesStatus.loading));

      final note= await getAllNotesUseCase.call(event.activityId, event.isUpdated,start: state.notes.length.toString());
      final notes = note.getOrElse(() => []);
      emit(notes.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
        status: NotesStatus.success,
        notes: List.of(state.notes)..addAll(notes),
        hasReachedMax: false,
      ));
    } catch (e) {
      emit(state.copyWith(status: NotesStatus.failure,message: e.toString()));
    }
  }

}
