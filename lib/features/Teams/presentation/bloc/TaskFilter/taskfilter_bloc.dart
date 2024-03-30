import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'taskfilter_event.dart';
part 'taskfilter_state.dart';

class TaskfilterBloc extends Bloc<TaskfilterEvent, TaskfilterState> {
  TaskfilterBloc() : super(TaskfilterInitial()) {
    on<TaskfilterEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<TaskfilterSelected>(onTaskfilterSelected);
    on<filterTask>(_filter);
  }
  void onTaskfilterSelected(TaskfilterSelected event, Emitter<TaskfilterState> emit) {
    emit(state.copyWith(selectedFilter: event.selectedFilter));
  }
  void _filter(filterTask event , Emitter<TaskfilterState> emit){
    emit(state.copyWith(tasks: event.tasks));
  }
}
