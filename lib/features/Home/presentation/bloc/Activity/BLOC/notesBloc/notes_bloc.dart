import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/strings/failures.dart';
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
  NotesBloc(this.getAllNotesUseCase, this.createNotesUseCases, this.updateNotesUseCases, this.deleteNotesUseCases) : super(NotesInitial()) {
    on<NotesEvent>((event, emit) {

      // TODO: implement event handler
    });
    on<Notesfetched>(_onNotesFetched,  transformer: throttleDroppable(throttleDuration),);
    on<createNoteEvent>(onNotesCreated);
    on<updateNote>(onNotesUpdated);
    on<deleteNote>(onNotesDeleted);
    on<resetNotes>(_reset);
    on<changeNoteActionEvent>(_updateAction);


  }
  final GetNotesOfActivityUseCase getAllNotesUseCase;
 final CreateNotesUseCases createNotesUseCases;
 final UpdateNotesUseCases updateNotesUseCases;
 final DeleteNotesUseCases deleteNotesUseCases;

  Future<void> _onNotesFetched(Notesfetched event, Emitter<NotesState> emit) async {

    try {
      if (state.status == NotesStatus.initial || state.status == NotesStatus.IsRefreshed ) {
        emit(state.copyWith(status: NotesStatus.loading));
        final notes = await getAllNotesUseCase.call(event.activityId, event.isUpdated);
        final note= notes.getOrElse(() => []);
        return emit(state.copyWith(
          status: NotesStatus.success,
          notes: note,
          hasReachedMax: false,
        ));
      }

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
  void _updateAction(changeNoteActionEvent event,Emitter<NotesState> emit){
    emit(state.copyWith(action: event.action,noteId: event.noteId));
  }

void _reset(resetNotes event ,Emitter<NotesState>emitter){

    emitter(state.copyWith(status:
    state.status==NotesStatus.IsRefreshed?
    NotesStatus.initial:NotesStatus.IsRefreshed,notes: [],hasReachedMax: false));
}

void onNotesUpdated(updateNote event,Emitter<NotesState> emit)async{
    try {
      final result=await updateNotesUseCases.call(event.note);
      emit(_updatedOrFailure(result,false, event.note.id));

          } on Exception catch (e) {

      emit(state.copyWith(status: NotesStatus.FailureCRUD,message: e.toString()));
      // TODO
    }

  }

  void onNotesDeleted(deleteNote event,Emitter<NotesState> emit)async{
    try {
      final result=await deleteNotesUseCases.call(event.note);
      emit(_updatedOrFailure(result,true,event.note.noteid!));

          } on Exception catch (e) {
      emit(state.copyWith(status: NotesStatus.FailureCRUD,message: e.toString()));
      // TODO
    }

  }

  void onNotesCreated(createNoteEvent event,Emitter<NotesState> emit)async{
    try {
      final result=await createNotesUseCases.call(event.note);
      emit(_CreatedOrFailure(result));

          } on Exception catch (e) {
      emit(state.copyWith(status: NotesStatus.FailureCRUD,message: e.toString()));
      // TODO
    }

  }

  NotesState _CreatedOrFailure(Either<Failure, Note> result) {
    return result.fold((l) => state.copyWith(status: NotesStatus.FailureCRUD,message: mapFailureToMessage(l)),
            (r) {
    final List<Note> updatedNotes = List.from(state.notes);
  updatedNotes.insert(0, r);
    return     state.copyWith(status: NotesStatus.Created,notes: updatedNotes);
    });
  }

  NotesState _updatedOrFailure(Either<Failure, Unit> result,bool isDeleted,String id) {
    return result.fold((l) => state.copyWith(status: NotesStatus.FailureCRUD,message: mapFailureToMessage(l)),
            (r) {
      if (isDeleted) {
        final List<Note> updatedNotes = List.from(state.notes);
        updatedNotes.removeWhere((element) => element.id==id);
        return state.copyWith(status: NotesStatus.Deleted,notes: updatedNotes);
      }

     return  state.copyWith(status: NotesStatus.Updated);
    });


}}
