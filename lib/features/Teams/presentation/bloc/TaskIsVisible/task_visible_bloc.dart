import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/Task.dart';

part 'task_visible_event.dart';
part 'task_visible_state.dart';

class TaskVisibleBloc extends Bloc<TaskVisibleEvent, TaskVisibleState> {
  TaskVisibleBloc() : super(TaskVisibleInitial()) {
    on<TaskVisibleEvent>((event, emit) {
    });
    on<ToggleTaskVisible>(_onToggleTaskVisible);
    on<DeletedTaskedEvent>(ondeleted);
    on<ChangeSectionEvent>(_ChangeSectionEvent);
    on<ChangeTextFieldsTitle>(_changeTextFieldsTitle);
    on<ChangeTextFieldsDescription>(_changeTextFieldsDescription);


  }
  void _onToggleTaskVisible(ToggleTaskVisible event, Emitter<TaskVisibleState> emit) {

    emit(state.copyWith(WillAdded: !event.WillVisible));
    log(state.WillAdded.toString());
  }
  void ondeleted(DeletedTaskedEvent event, Emitter<TaskVisibleState> emit) {

    emit(state.copyWith(WillDeleted: !event.deleted));
    log(state.WillDeleted.toString());
  }

void _changeTextFieldsTitle(ChangeTextFieldsTitle event, Emitter<TaskVisibleState> emit) {
    emit(state.copyWith(textFieldsTitle: event.textFieldsTitle));
  }
  void _changeTextFieldsDescription(ChangeTextFieldsDescription event, Emitter<TaskVisibleState> emit) {
    emit(state.copyWith(textFieldsDescription: event.textFieldsDescription));
  }

  void resetTaskVisible( Emitter<TaskVisibleState> emit) {
    emit(TaskVisibleInitial());
  }

  void _ChangeSectionEvent(ChangeSectionEvent event, Emitter<TaskVisibleState> emit) {
    emit(state.copyWith(section: event.section));
  }


}
