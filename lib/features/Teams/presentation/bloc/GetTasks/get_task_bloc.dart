import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/features/Teams/domain/entities/Task.dart';

import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../data/models/TaskModel.dart';
import '../../../domain/usecases/TaskUseCase.dart';
import '../TaskIsVisible/task_visible_bloc.dart';

part 'get_task_event.dart';
part 'get_task_state.dart';

class GetTaskBloc extends Bloc<GetTaskEvent, GetTaskState> {
  final GetTasksOfTeamUseCase getTasksOfTeamUseCase;
  final GetTasksByIdUseCase getTasksByIdUseCase;  final AddTaskUseCase addTaskUseCase;



  GetTaskBloc(this.getTasksOfTeamUseCase, this.getTasksByIdUseCase, this.addTaskUseCase,) : super(GetTaskInitial()) {
        on<GetTasks>(onGetTasks,);
    on<GetTaskById>(onGetTaskById);
    on<CreateTask>(_CreateTask);
    on<resetevent>(reset);
  }
void reset(resetevent event, Emitter<GetTaskState> emit) {
  emit(state.copyWith(status: TaskStatus.initial, tasks: []));
}
 void onGetTasks(GetTasks event, Emitter<GetTaskState> emit) async {


      try {
        if (state.status == TaskStatus.initial){
        final result = await getTasksOfTeamUseCase(event.id);
            emit(state.copyWith(tasks: result.getOrElse(() => []),status: TaskStatus.success));
        }
      } on Exception catch (e) {
        emit(state.copyWith(status: TaskStatus.error, errorMessage: "An error occurred"));
      }

  }
  void onGetTaskById(GetTaskById event, Emitter<GetTaskState> emit) async {
    emit(GetTaskLoading());
    try {
      final result = await getTasksByIdUseCase(event.ids);
      emit(_mapFailureOrTaskByIdToState(result));
    } catch (error) {
      emit(GetTaskError(message: 'An error occurred'));
    }
  }



  GetTaskState _mapFailureOrTaskByIdToState(Either<Failure, Tasks> either) {
    return either.fold(
          (failure) => GetTaskError(message:mapFailureToMessage(failure)),
          (act) =>
          GetTaskByIdLoaded(
            task:act,
          ),
    );
  }
  void _CreateTask(CreateTask event, Emitter <GetTaskState> emit) async {
    try {

      final result = await addTaskUseCase(event.task);
      emit(_mapFailureOrAddedToState(result,emit));
    } catch (error) {
      emit(AddTaskError(message: "An error occurred"));
    }
  }


  GetTaskState _mapFailureOrAddedToState(Either<Failure, Tasks> either,Emitter<GetTaskState> emit) {
    return either.fold(
            (failure) => AddTaskError(message: mapFailureToMessage(failure),),
            (act) {
        return      state.copyWith(tasks: UnmodifiableListView(
                [
                  act,...state.tasks
                ],));
log(state.tasks.length.toString());


          }
    );
  }
}
