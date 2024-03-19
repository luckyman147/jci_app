import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../domain/entities/Task.dart';
import '../../../domain/usecases/TaskUseCase.dart';
import '../TaskIsVisible/task_visible_bloc.dart';

part 'task_actions_event.dart';
part 'task_actions_state.dart';

class TaskActionsBloc extends Bloc<TaskActionsEvent, TaskActionsState> {
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;

final TaskVisibleBloc taskVisibleBloc;
  TaskActionsBloc(this.addTaskUseCase, this.updateTaskUseCase, this.taskVisibleBloc)
      : super(TaskActionsInitial()) {
    on<TaskActionsEvent>((event, emit) {

    });
   // on<CreateTask>(_CreateTask);
  }


}