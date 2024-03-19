import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/Task.dart';

part 'task_visible_event.dart';
part 'task_visible_state.dart';

class TaskVisibleBloc extends Bloc<TaskVisibleEvent, TaskVisibleState> {
  TaskVisibleBloc() : super(TaskVisibleInitial(false,[])) {
    on<TaskVisibleEvent>((event, emit) {
    });
    on<ToggleTaskVisible>(_onToggleTaskVisible);
    on<FullTasks>(_onFullTasks);
    on<AddedTaskedEvent>(_onAddedTaskedEvent);
  }
  void _onToggleTaskVisible(ToggleTaskVisible event, Emitter<TaskVisibleState> emit) {

    emit(state.copyWith(WillAdded: !event.WillVisible));
    log(state.WillAdded.toString());
  }

  void _onFullTasks(FullTasks event, Emitter<TaskVisibleState> emit) {
    emit(state.copyWith(tasks: UnmodifiableListView(
    event.tasks,
    )));
    log("ssss"+state.tasks.length.toString());

  }
  void _onAddedTaskedEvent(AddedTaskedEvent event, Emitter<TaskVisibleState> emit) {
 final result=   List.of(state.tasks)..add(event.task);
    emit(state.copyWith(tasks: UnmodifiableListView(
   [event.task,
     ...state.tasks,

   ],)));
  }
  void resetTaskVisible( Emitter<TaskVisibleState> emit) {
    emit(TaskVisibleInitial(false,[]));
  }



}
