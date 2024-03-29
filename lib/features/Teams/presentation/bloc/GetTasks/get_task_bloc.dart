import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/features/Teams/domain/entities/Task.dart';
import 'package:jci_app/features/Teams/presentation/widgets/funct.dart';

import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../../auth/domain/entities/Member.dart';
import '../../../data/models/TaskModel.dart';
import '../../../domain/entities/Checklist.dart';
import '../../../domain/usecases/TaskUseCase.dart';
import '../TaskIsVisible/task_visible_bloc.dart';

part 'get_task_event.dart';
part 'get_task_state.dart';

class GetTaskBloc extends Bloc<GetTaskEvent, GetTaskState> {
  final GetTasksOfTeamUseCase getTasksOfTeamUseCase;
  final GetTasksByIdUseCase getTasksByIdUseCase;  final AddTaskUseCase addTaskUseCase;
  final AddChecklistUseCase addChecklistUseCase;
final UpdateIsCompletedUseCases updateIsCompletedUseCases;
final UpdateChecklistStatusUseCase updateChecklistStatusUseCase;
final DeleteTaskUseCase deleteTaskUseCase;
final DeleteChecklistUseCase deleteChecklistUseCase;
final UpdateTaskNameUseCase updateTaskNameUseCase;
final UpdateTaskTimelineUseCase updateTaskTimelineUseCase;
final UpdateMembersUsecases UpdateMembersUseCase;
  GetTaskBloc({ required this.getTasksOfTeamUseCase, required this.getTasksByIdUseCase,
  required this.addTaskUseCase,required this.addChecklistUseCase,
  required this.updateTaskNameUseCase,
  required this.updateTaskTimelineUseCase,
    required this.UpdateMembersUseCase,
  required this.updateIsCompletedUseCases, required this.deleteTaskUseCase,
  required this.deleteChecklistUseCase, required this.updateChecklistStatusUseCase,}) : super(GetTaskInitial()) {
        on<GetTasks>(onGetTasks,);
    on<GetTaskById>(onGetTaskById);
    on<CreateTask>(_CreateTask);
    on<AddCheckList>(_CreateChecklist);

    on<UpdateStatus>(taskStatusUpdated);
    on<initTasks>(_initTasks);
    on<DeleteChecklist>(deleteChecklist);
    on<DeleteTask>(deleteTask);
    on<UpdateChecklistStatus>(_ChecklistStatusUpdated);
    on<UpdateTimeline>(_taskUpdateTime);
    on<UpdateTaskName>(_updatetaskName);
    on<UpdateMember>(_updateMembers);
    on<init_members>(_init_members);


    on<resetevent>(reset);

  }






  void _updateMembers(UpdateMember event, Emitter<GetTaskState> emit) async {
    try {
      final result = await UpdateMembersUseCase(event.fields);
      if (event.fields['status'] as bool ==true){


        List<Map<String, dynamic>> updatedTasks = AddSousFieldAction(event.fields['taskid']!,
            toMapMember(event.fields['member']as Member), "AssignTo");

checkState(emit, updatedTasks);

log(state.tasks.toString());
      }else{
        final updatedTasks=[...state.tasks.map((task) {
          if (task['id'] == event.fields['taskid']) {
            // Remove the checklist with the matching ID
            task['AssignTo'] = UnmodifiableListView(task['AssignTo'].where((member) => member['id'] != event.fields['memberId'] && member['_id'] != event.fields['memberId']).toList());
            log(task['AssignTo'].toString()+"ddd");
          }
          return task;
        })];
        checkState(emit, updatedTasks);
      }

    } catch (e) {
      emit(state.copyWith(status: TaskStatus.error, errorMessage: "An error occurred"));
    }
  }



  void deleteTask(DeleteTask event, Emitter<GetTaskState> emit) async {
    try {
      final result = await deleteTaskUseCase(event.id);
      final updatedTasks =UnmodifiableListView( [...state.tasks.where((task) => task['id'] != event.id)]);

  checkState(emit, updatedTasks);
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.error, errorMessage: "An error occurred"));
    }
  }
void deleteChecklist(DeleteChecklist event, Emitter<GetTaskState> emit) async {
    try {
      final result = await deleteChecklistUseCase(event.checklistId);
      final updatedTasks = [...state.tasks.map((task) {
        if (task['id'] == event.id) {
          // Remove the checklist with the matching ID
          task['CheckLists'] = UnmodifiableListView(task['CheckLists'].where((checklist) => checklist['id'] != event.checklistId).toList());
        }
        return task;
      })];

checkState(emit, updatedTasks);

    }
     catch (e) {
      emit(state.copyWith(status: TaskStatus.error, errorMessage: "An error occurred"));
    }
  }
  void _initTasks(initTasks event, Emitter<GetTaskState> emit) {
    emit(state.copyWith(tasks: event.tasksInit));
  }
  void _init_members(init_members event, Emitter<GetTaskState> emit) {
    UpdateTaskField(event,emit,'AssignTo',event.members,event.id);
  }
void reset(resetevent event, Emitter<GetTaskState> emit) {
  emit(state.copyWith(status: TaskStatus.initial, tasks: [],));
}
 void onGetTasks(GetTasks event, Emitter<GetTaskState> emit) async {


      try {
        if (state.status == TaskStatus.initial || state.status == TaskStatus.error|| state.status == TaskStatus.Changed){
        final result = await getTasksOfTeamUseCase(event.id);
        final r= result.getOrElse(() => []);
            emit(state.copyWith(tasks: r.map((e) => toMap(e)).toList(),status: TaskStatus.success,




            ));
        }
      } on Exception catch (e) {
        emit(state.copyWith(status: TaskStatus.error, errorMessage: ""));
      }

  }
  void onGetTaskById(GetTaskById event, Emitter<GetTaskState> emit) async {

    try {
      if (state.status == TaskStatus.Loading){

      final result = await getTasksByIdUseCase(event.ids);

      emit(_mapFailureOrTaskByIdToState(result));

      }
    } catch (error) {
      emit(GetTaskError(message: 'An error occurred'));
    }
  }
void taskStatusUpdated(UpdateStatus event, Emitter<GetTaskState> emit) async {
    try{
      final result = await updateIsCompletedUseCases(event.isCompleted);
      log(event.isCompleted['IsCompleted'].toString());
      UpdateTaskField(event, emit,"isCompleted",event.isCompleted['IsCompleted'] ,event.isCompleted['id']!);
      log(state.status.toString());
    }
    catch(e){
      log(e.toString());
      emit(state.copyWith(status: TaskStatus.error, errorMessage: "An error occurred"));
    }

}
void _taskUpdateTime(UpdateTimeline event, Emitter<GetTaskState> emit) async {
    try{
      log(event.timeline.toString()+"timeline");
      final result = await updateTaskTimelineUseCase(event.timeline);

      UpdateTimelineFun(event, emit,);
      log(state.status.toString());
    }
    catch(e){
      log(e.toString());
      emit(state.copyWith(status: TaskStatus.error, errorMessage: "An error occurred"));
    }

}

void UpdateTaskField(GetTaskEvent event, Emitter<GetTaskState> emit,String field,dynamic value,String id) {
     final act = findTaskById(state.tasks, id);
  act[field] = value;
  List<Map<String, dynamic>> updatedTasks = List.from(state.tasks);
  updatedTasks[updatedTasks.indexOf(act)] = act;
  checkState(emit, updatedTasks);
}


void                        UpdateTimelineFun(UpdateTimeline event, Emitter<GetTaskState> emit,) {
     final act = findTaskById(state.tasks, event.timeline['id']);
  act["StartDate"] = event.timeline['StartDate'];
  act["Deadline"] = event.timeline['Deadline'];
  List<Map<String, dynamic>> updatedTasks = List.from(state.tasks);
  updatedTasks[updatedTasks.indexOf(act)] = act;
  checkState(emit, updatedTasks);
}

void checkState(Emitter<GetTaskState> emit, List<Map<String, dynamic>> updatedTasks) {
   if (state.status == TaskStatus.success){
  emit (    state.copyWith(tasks: updatedTasks,status: TaskStatus.Changed ));
  log(state.status.toString());
  }
  else {
  emit (    state.copyWith(tasks: updatedTasks,status: TaskStatus.success ));
  log(state.status.toString());}
}

void _ChecklistStatusUpdated(UpdateChecklistStatus event, Emitter<GetTaskState> emit) async {
    try{
      final result = await updateChecklistStatusUseCase(event.checklist);
      emit(_mapFailureOrUpdatedChecklistStatusToState(result,emit,event.checklist['taskid']!,event.checklist['checkid']!,event.checklist['IsCompleted']! as bool));
    }
    catch(e){
      log(e.toString());
      emit(state.copyWith(status: TaskStatus.error, errorMessage: "An error occurred"));
    }
  }
void _updatetaskName (UpdateTaskName event, Emitter<GetTaskState> emit) async {
    try{
      final result = await updateTaskNameUseCase(event.fields);
      UpdateTaskField(event, emit,"name",event.fields['name'] ,event.fields['taskid']!);
    }
    catch(e){
      log(e.toString());
      emit(state.copyWith(status: TaskStatus.error, errorMessage: "An error occurred"));
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
      log(''''message''');
    } catch (error) {
      emit(AddTaskError(message: "An error occurred"));
    }
  }

  void _CreateChecklist(AddCheckList event, Emitter <GetTaskState> emit) async {
    try {

      final result = await addChecklistUseCase(event.checklist);
      emit(_mapFailureOrAddedChecklistToState(result,emit,event.checklist['idTask']!));
      log(''''message''');
      log(state.status.toString());
    } catch (error) {
      emit(AddTaskError(message: "No Tasks found, "));
    }
  }


  GetTaskState _mapFailureOrAddedToState(Either<Failure, Tasks> either,Emitter<GetTaskState> emit) {
    return either.fold(
            (failure) => AddTaskError(message: mapFailureToMessage(failure),),
            (act) {
        return      state.copyWith(tasks: UnmodifiableListView(
                [
                  toMap(act),...state.tasks
                ],),
          status: TaskStatus.success,

        );



          }
    );
  }
  GetTaskState _mapFailureOrAddedChecklistToState(Either<Failure, CheckList> either,Emitter<GetTaskState> emit,String id) {
    return either.fold(
            (failure) => AddTaskError(message: 'No task found ',),
            (act) {
              List<Map<String, dynamic>> updatedTasks = AddSousFieldAction(id, toMapChecklist(act),"CheckLists");

              return state.copyWith(tasks: updatedTasks, status: TaskStatus.Changed,);
          }
    );
  }

  List<Map<String, dynamic>> AddSousFieldAction(String id, dynamic act,String field) {
    Map<String, dynamic> updatedTask = findTaskById(state.tasks, id);

    List<Map<String, dynamic>> updatedCheckLists = List.from(updatedTask[field]);
    updatedCheckLists.insert(0, act);

    updatedTask[field] = updatedCheckLists;

    List<Map<String, dynamic>> updatedTasks = List.from(state.tasks);
    updatedTasks[updatedTasks.indexOf(updatedTask)] = updatedTask;
    return updatedTasks;
  }
  GetTaskState _mapFailureOrUpdatedChecklistStatusToState(Either<Failure, Unit> either, Emitter<GetTaskState> emit, String id, String checkid, bool newche) {
    return either.fold(
            (failure) {
              log(failure.toString());
              return AddTaskError(message: mapFailureToMessage(failure),);
            },
            (act) {
          Map<String, dynamic> updatedTask = findTaskById(state.tasks, id);
            List<Map<String, dynamic>> updatedCheckLists = List.from(updatedTask['CheckLists']);
            int index = updatedCheckLists.indexWhere((checklist) => checklist['id'] == checkid);

          List<Map<String, dynamic>> updatedTasks = changeChecklist(
              updatedCheckLists, index, newche, updatedTask, "isCompleted", "CheckLists");
          return state.copyWith(tasks: updatedTasks, status: state.status==TaskStatus.Changed?
          TaskStatus.success: TaskStatus.Changed ,);
        }
    );
  }

 List<Map<String, dynamic>> changeChecklist(List<Map<String, dynamic>> updatedCheckLists,
     int index, bool newche, Map<String, dynamic> updatedTask,String sousfield,String field) {
    updatedCheckLists[index][sousfield] = newche;
    log(updatedCheckLists[index][sousfield].toString());

   updatedTask[field] = updatedCheckLists;
    List<Map<String, dynamic>> updatedTasks = List.from(state.tasks);
    updatedTasks[updatedTasks.indexOf(updatedTask)] = updatedTask;
   return updatedTasks;
 }
}

