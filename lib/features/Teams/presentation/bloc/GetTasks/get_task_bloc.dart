import 'dart:collection';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:jci_app/features/Teams/domain/entities/task/Task.dart';
import 'package:jci_app/features/Teams/presentation/utils/ChecklistUtils.dart';
import 'package:jci_app/features/Teams/presentation/utils/MemberUtils.dart';
import 'package:jci_app/features/Teams/presentation/utils/TaskUtils.dart';


import '../../../../../core/PrimitiveUser/User.dart';
import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';

import '../../../domain/dto/TaskIdParams.dart';
import '../../../domain/entities/Checklist.dart';
import '../../../domain/usecases/TaskUseCase.dart';
import '../TaskFilter/taskfilter_bloc.dart';


part 'get_task_event.dart';
part 'get_task_state.dart';

class GetTaskBloc extends Bloc<GetTaskEvent, GetTaskState> {
  final GetTasksOfTeamUseCase getTasksOfTeamUseCase;
  final GetTaskByIdUseCase getTasksByIdUseCase;
  final AddTaskUseCase addTaskUseCase;

  final DeleteTaskUseCase deleteTaskUseCase;

  final updateTaskNameUseCase UpdateTaskNameUseCase;
 // final UpdateFileUseCase updateFileUseCase;
  final UpdateTaskTimeline updateTaskTimelineUseCase;
  final UpdateMembersUseCase updateMembersUseCase;
 // final DeleteFileUseCases deleteFileUseCase;
 // final AddCommentUseCase addCommentUseCase;
  //final GetFileUseCase getFileUseCase;
  GetTaskBloc({ required this.getTasksOfTeamUseCase, required this.getTasksByIdUseCase,
    required this.addTaskUseCase,
    required this.UpdateTaskNameUseCase,
    required this.updateTaskTimelineUseCase,
    required this.updateMembersUseCase,

   required this.deleteTaskUseCase,

  })

      : super(const GetTaskInitial()) {
    on<GetTasks>(onGetTasks,);
    on<GetTaskById>(onGetTaskById);
    on<CreateTask>(_CreateTask);



    on<UpdateStatus>(taskStatusUpdated);
    on<initTasks>(_initTasks);

    on<DeleteTask>(deleteTask);

    on<UpdateTimeline>(_taskUpdateTime);
    on<UpdateTaskNameEvent>(_updatetaskName);
    on<UpdateMember>(_updateMembers);
    on<init_members>(_init_members);


    on<resetevent>(reset);

  }

void _updatetaskName(UpdateTaskNameEvent event, Emitter<GetTaskState> emit) async {
    try {
      final result = await UpdateTaskNameUseCase(event.fields);
      emit(_mapFailureOrSuccess(result,emit,(task){

      }));
    } catch (error) {
      emit(state.copyWith(status: TaskStatus.ErrorUpdate, errorMessage: "$error + error occurred"));
    }
  }

 /*void _deleteFile(DeleteFileEvent event ,Emitter<GetTaskState> emit)async {
    if (event.fields.fileid == null) {
      emit(state.copyWith(status: TaskStatus.ErrorUpdate, errorMessage: "An error occurred"));
      return;
    }
    try{
      final result = await deleteFileUseCase(event.fields);
      _eitherdeleteFileorFailure(result, emit, event);
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.ErrorUpdate, errorMessage: "$e + error occurred"));
    }
  }*/
/*
  void _eitherdeleteFileorFailure(Either<Failure, Unit> result, Emitter<GetTaskState> emit, DeleteFileEvent event) {
    result.fold((l) {
      emit(state.copyWith(status: TaskStatus.ErrorUpdate, errorMessage: "$l + error occurred"));
    }, (r) {

      final updatedTasks = [...state.tasks.map((task) {
        if (task['id'] == event.fields.taskid) {
          // Remove the checklist with the matching ID
          task['attachedFile'] = UnmodifiableListView<Map<String, dynamic>>(
            task['attachedFile']
                .where((checklist) => checklist['id'] != event.fields.fileid)
                .map<Map<String, dynamic>>((element) => element as Map<String, dynamic>)
                .toList(),
          );          }
        return task;
      })];

      checkState(emit, updatedTasks);
    });
  }


  void _updateFiles(UpdateFile event, Emitter<GetTaskState> emit) async {

    try {
      final result = await updateFileUseCase(event.fields);
      result.fold((l) {
        emit(state.copyWith(status: TaskStatus.ErrorUpdate, errorMessage: "$l + error occurred"));
      }, (r) {

        List<Map<String, dynamic>> updatedTasks = AddSousFieldAction(event.fields.taskid,
            CheckListUtils.toMapFile(r), "attachedFile");

        checkState(emit, updatedTasks);

      });
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.error, errorMessage: "$e"));
    }
  }
*/

  void _updateMembers(UpdateMember event, Emitter<GetTaskState> emit) async {
    try {
      final result = await updateMembersUseCase(event.fields);

      _updatedMember(event, emit);

    } catch (e) {
      emit(state.copyWith(status: TaskStatus.error, errorMessage: "$e"));
    }
  }

  void _updatedMember(UpdateMember event, Emitter<GetTaskState> emit) {
    if (event.fields.memberStatus==true){




    }else{


    }
  }



  void deleteTask(DeleteTask event, Emitter<GetTaskState> emit) async {
    try {
      final result = await deleteTaskUseCase(event.id);
   //   final updatedTasks =UnmodifiableListView( [...state.tasks.where((task) => task.meta.id != event.id.taskId)]);

     // checkState(emit, updatedTasks);
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.error, errorMessage: "An error occurred"));
    }
  }

  void _initTasks(initTasks event, Emitter<GetTaskState> emit) {
    emit(state.copyWith(clonetasks: event.tasksInit,status: TaskStatus.success,));
  }
  void _init_members(init_members event, Emitter<GetTaskState> emit) {
  //  UpdateTaskField(event,emit,'AssignTo',event.members,event.id);
  }
  void reset(resetevent event, Emitter<GetTaskState> emit) {
    emit(state.copyWith(status: TaskStatus.initial, Completedtasks: [],
        Delayedtasks: [],
        Todotasks: [],
        InProgresstasks: [],

        clonetasks: []));
  }
  void onGetTasks(GetTasks event, Emitter<GetTaskState> emit) async {


    try {
      if (state.status == TaskStatus.initial || state.status == TaskStatus.error|| state.status == TaskStatus.Changed){
        final result = await getTasksOfTeamUseCase(event.id);
        final r= result.getOrElse(() => []);
        final grouped = groupTasksByStatus(r);

        emit(state.copyWith(

          clonetasks: r,
          Todotasks: grouped[TaskCompletionStatus.Todo]!,
          InProgresstasks: grouped[TaskCompletionStatus.InProgress]!,
          Completedtasks: grouped[TaskCompletionStatus.Completed]!,
          Delayedtasks: grouped[TaskCompletionStatus.Delayed]!,
          status: TaskStatus.success,
        ));

      }
    } on Exception {
      emit(state.copyWith(status: TaskStatus.error, errorMessage: ""));
    }

  }
  void onGetTaskById(GetTaskById event, Emitter<GetTaskState> emit) async {

    try {
      if (state.status == TaskStatus.Loading){

        final result = await getTasksByIdUseCase(event.ids);

        emit(_mapFailureOrSuccess(result,emit,(task){
          return state.copyWith(task: task, status: TaskStatus.success);
        }));

      }
    } catch (error) {
    }
  }
  void taskStatusUpdated(UpdateStatus event, Emitter<GetTaskState> emit) async {
    try{
 //     final result =  UpdateTaskStatusUseCase(event.isCompleted);

   //   UpdateTaskField(event, emit,"isCompleted",event.isCompleted.isCompleted ,event.isCompleted.taskid);

    }
    catch(e){
      log(e.toString());
      emit(state.copyWith(status: TaskStatus.error, errorMessage: "An error occurred"));
    }

  }
  void _taskUpdateTime(UpdateTimeline event, Emitter<GetTaskState> emit) async {
    try{
      log("${event.timeline}timeline");
      final result = await updateTaskTimelineUseCase(event.timeline);

      UpdateTimelineFun(event, emit,);
      log(state.status.toString());
    }
    catch(e){
      log(e.toString());
      emit(state.copyWith(status: TaskStatus.error, errorMessage: "An error occurred"));
    }

  }



  void                        UpdateTimelineFun(UpdateTimeline event, Emitter<GetTaskState> emit,) {

  }








  void _CreateTask(CreateTask event, Emitter <GetTaskState> emit) async {
    try {



    } catch (error) {
      emit(state.copyWith(status: TaskStatus.ErrorUpdate, errorMessage: "$error + error occurred"));

    }
  }
  GetTaskState _mapFailureOrSuccess<T>(
      Either<Failure, T> failureOrChecklist, Emitter<GetTaskState> emit, Function(T) onSuccess) {
    return failureOrChecklist.fold(
          (failure) => state.copyWith(status: TaskStatus.error, ),
          (task) {
        return onSuccess(task);
      },
    );
  }


  Map<TaskCompletionStatus, List<Tasks>> groupTasksByStatus(List<Tasks> tasks) {
    final Map<TaskCompletionStatus, List<Tasks>> groupedTasks = {
      TaskCompletionStatus.Todo: [],
      TaskCompletionStatus.InProgress: [],
      TaskCompletionStatus.Completed: [],
      TaskCompletionStatus.Delayed: [],
    };

    for (final task in tasks) {
      groupedTasks[task.meta.status]?.add(task);
    }

    return groupedTasks;
  }





/*  List<Map<String, dynamic>> changeChecklist(List<Map<String, dynamic>> updatedCheckLists,
      int index, dynamic newche, Map<String, dynamic> updatedTask,String sousfield,String field) {
    updatedCheckLists[index][sousfield] = newche;
    log(updatedCheckLists[index][sousfield].toString());

    updatedTask[field] = updatedCheckLists;
    List<Map<String, dynamic>> updatedTasks = List.from(state.tasks);
    updatedTasks[updatedTasks.indexOf(updatedTask)] = updatedTask;
    return updatedTasks;
  }

  GetTaskState _GetFile(Either<Failure, Uint8List> file, ) {
    return file.fold(
            (failure) => state.copyWith(status: TaskStatus.error, errorMessage: mapFailureToMessage(failure))
        ,
            (act) {

          return state.copyWith(status: TaskStatus.success, image: act);
        }
    );
  }*/
}