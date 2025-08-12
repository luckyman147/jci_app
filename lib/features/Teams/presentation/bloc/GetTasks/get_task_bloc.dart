import 'dart:collection';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/features/Teams/domain/entities/task/Comment.dart';
import 'package:jci_app/features/Teams/presentation/utils/CommentsUtils.dart';
import 'package:logger/logger.dart';
import 'package:jci_app/features/Teams/domain/entities/task/Task.dart';
import 'package:jci_app/features/Teams/presentation/utils/ChecklistUtils.dart';
import 'package:jci_app/features/Teams/presentation/utils/MemberUtils.dart';
import 'package:jci_app/features/Teams/presentation/utils/TaskUtils.dart';


import '../../../../../core/PrimitiveUser/User.dart';
import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';

import '../../../data/models/TaskModel.dart';
import '../../../domain/dto/TaskIdParams.dart';
import '../../../domain/entities/Checklist.dart';
import '../../../domain/entities/TeamUser.dart';
import '../../../domain/usecases/CheckList_usescases.dart';
import '../../../domain/usecases/TaskUseCase.dart';
import '../TaskFilter/taskfilter_bloc.dart';


part 'get_task_event.dart';
part 'get_task_state.dart';

class GetTaskBloc extends Bloc<GetTaskEvent, GetTaskState> {
  final GetTasksOfTeamUseCase getTasksOfTeamUseCase;
  final GetTaskByIdUseCase getTasksByIdUseCase;
  final AddTaskUseCase addTaskUseCase;

  final DeleteTaskUseCase deleteTaskUseCase;
  final UpdateChecklistNameUseCase updateChecklistNameUseCase;
  final DeleteChecklistUseCase deleteChecklistUseCase;
  final AddChecklistUseCase addChecklistUseCase;
  final UpdateChecklistStatusUseCase updateChecklistStatusUseCase;

  final updateTaskNameUseCase UpdateTaskNameUseCase;
  final updateTaskDescriptionUseCase UpdateTaskDescriptionUseCase;
 // final UpdateFileUseCase updateFileUseCase;
  final UpdateTaskTimeline updateTaskTimelineUseCase;
  final UpdateMembersUseCase updateMembersUseCase;
   final updateTaskStatusUseCase UpdateTaskStatusUseCase;
 // final DeleteFileUseCases deleteFileUseCase;
 // final AddCommentUseCase addCommentUseCase;
  //final GetFileUseCase getFileUseCase;
  GetTaskBloc({ required this.getTasksOfTeamUseCase,

    required this.addChecklistUseCase,
    required this.updateChecklistNameUseCase,
    required this.updateChecklistStatusUseCase,
    required this.deleteChecklistUseCase,



    required this.getTasksByIdUseCase,
    required this.UpdateTaskStatusUseCase,
    required this.addTaskUseCase,
    required this.UpdateTaskNameUseCase,
    required this.UpdateTaskDescriptionUseCase,

    required this.updateTaskTimelineUseCase,
    required this.updateMembersUseCase,

   required this.deleteTaskUseCase,

  })

      : super(const GetTaskInitial()) {
    on<GetTasks>(onGetTasks,);
    on<GetTaskById>(onGetTaskById);
    on<CreateTask>(_CreateTask);
    on<AddInitCommentEvent>((event,emit){
      emit(_mapSuccess(emit, event.comment!.TaskId,  (task){
        final updatedcomments = CommentsUtils.addComment(
          task.communication.comments, event.comment,
        );
        Logger().d("Updated comments: ${updatedcomments.length} items");
        final updatedMeta = task.communication.copyWith(comments: updatedcomments);
        return task.copyWith(communication: updatedMeta);
      }));
    });
    on<AddCommentIdEvent>((event,emit){
      emit (_mapSuccess(emit,event.taskId , (task){
        final updatedcomments = CommentsUtils.updateEmptyIdWithNewId(
          task.communication.comments, event.commentId,
        );
        Logger().d("Updated comments: ${updatedcomments.length} items");
        final updatedMeta = task.communication.copyWith(comments: updatedcomments);
        return task.copyWith(communication: updatedMeta);
      }));
    });
    on<AddChecklistEvent>(_onAddChecklist);
    on<UpdateChecklistStatusEvent>(_onUpdateChecklistStatus);
    on<UpdateChecklistNameEvent>(_onUpdateChecklistName);
    on<DeleteChecklistEvent>(_onDeleteChecklist);


    on<UpdateStatus>(taskStatusUpdated);
    on<initTasks>(_initTasks);
    on<initTask>(_initTask);

    on<DeleteTask>(deleteTask);

    on<UpdateTimeline>(_taskUpdateTime);
    on<UpdateTaskNameEvent>(_updatetaskName);
    on<UpdateTaskDescriptionEvent>(_updatetaskdes);
    on<UpdateMember>(_updateMembers);
    on<init_members>(_init_members);


    on<resetevent>(reset);

  }

void _updatetaskName(UpdateTaskNameEvent event, Emitter<GetTaskState> emit) async {
    try {
      // Update the task list before calling the use case
      final updatedTasks = state.tasks.map((task) {

        if (task.meta.id == event.fields.taskId) {
          // Update the task's status
          final updatedMeta = task.meta.copyWith(name: event.fields.name);

          return task.copyWith(meta: updatedMeta); // Return a new task with the updated meta
        }
        return task; // Keep the other tasks unchanged
      }).toList();

      // Emit the updated task list in the state
      emit(state.copyWith(
        status: TaskStatus.success, // Indicating success state
        tasks: updatedTasks, // Updated task list
        clonetasks: updatedTasks, // If you need to update this as well
      ));
       await UpdateTaskNameUseCase(event.fields);

    } catch (error) {
      emit(state.copyWith(status: TaskStatus.ErrorUpdate, errorMessage: "$error + error occurred"));
    }
  }void _updatetaskdes(UpdateTaskDescriptionEvent event, Emitter<GetTaskState> emit) async {
    try {
      // Update the task list before calling the use case
      final updatedTasks = state.tasks.map((task) {

        if (task.meta.id == event.fields.taskId) {
          // Update the task's status
          final updatedMeta = task.content.copyWith(description: event.fields.descriptionb);

          return task.copyWith(content: updatedMeta); // Return a new task with the updated meta
        }
        return task; // Keep the other tasks unchanged
      }).toList();

      // Emit the updated task list in the state
      emit(state.copyWith(
        task: updatedTasks.firstWhere((task) => task.meta.id == event.fields.taskId, ),
        status: TaskStatus.success, // Indicating success state
        tasks: updatedTasks, // Updated task list
        clonetasks: updatedTasks, // If you need to update this as well
      ));
       await UpdateTaskDescriptionUseCase(event.fields);

    } catch (error) {
      emit(state.copyWith(status: TaskStatus.ErrorUpdate, errorMessage: "$error + error occurred"));
    }
  }

  Future<void> _onAddChecklist(AddChecklistEvent event, Emitter<GetTaskState> emit) async {
try{
 emit ( _mapSuccess(emit, event.taskId, (task) {
        final updatedChecklists = CheckListUtils.addChecklist(
          task.content.checkLists, CheckList(name: event.name, id: '', isCompleted: false),
        );
        Logger().d("Updated checklists: ${updatedChecklists.length} items");
        final updatedMeta = task.content.copyWith(checkLists: updatedChecklists);
        return task.copyWith(content: updatedMeta);
      }));
   await addChecklistUseCase(
      ChecklistParams(
        teamId: event.teamId,
        taskId: event.taskId,
        name: event.name, checkId: '', isCompleted: false,
      ),

    );


}
catch(e){
  emit(state.copyWith(status: TaskStatus.ErrorUpdate, errorMessage: "$e + error occurred"));

    }
  }

  Future<void> _onUpdateChecklistStatus(UpdateChecklistStatusEvent event, Emitter<GetTaskState> emit) async {


    try{
 emit(     _mapSuccess(emit, event.taskId, (task){

        final updatedChecklists = CheckListUtils.updateChecklistStatus(
          task.content.checkLists, event.checkId, event.isCompleted,
        );
        Logger ().d( "Updated checklists: ${updatedChecklists} items");

        final updatedMeta = task.content.copyWith(checkLists: updatedChecklists);
        return task.copyWith(content: updatedMeta);

      }));
    final result = await updateChecklistStatusUseCase(
      ChecklistParams(
        teamId: event.teamId,
        taskId: event.taskId,
        checkId: event.checkId,
        isCompleted: event.isCompleted, name: "",
      ),
    );}
catch(e){
  emit(state.copyWith(status: TaskStatus.ErrorUpdate, errorMessage: "$e + error occurred"));


}
  }

  Future<void> _onUpdateChecklistName(UpdateChecklistNameEvent event, Emitter<GetTaskState> emit) async {
try {
 emit( _mapSuccess(emit, event.checklistParams.taskId, (task) {
    final updatedChecklists = CheckListUtils.updateChecklistName(
      task.content.checkLists, event.checklistParams.checkId,
      event.checklistParams.name,
    );
    final updatedMeta = task.content.copyWith(checkLists: updatedChecklists);
    return task.copyWith(content: updatedMeta);
  }));
  final result = await updateChecklistNameUseCase(event.checklistParams);
}
catch (e) {
  emit(state.copyWith(status: TaskStatus.ErrorUpdate, errorMessage: "$e + error occurred"));
}
  }

  Future<void> _onDeleteChecklist(DeleteChecklistEvent event, Emitter<GetTaskState> emit) async {
try {
 emit( _mapSuccess(emit, event.taskId, (task) {
    final updatedChecklists = CheckListUtils.deleteChecklist(
      task.content.checkLists, event.checkId,
    );
    Logger().d("Updated checklists after deletion: ${updatedChecklists.length} items");
    final updatedMeta = task.content.copyWith(checkLists: updatedChecklists);
    Logger().d("Updated task meta after deletion: ${updatedMeta.checkLists.length} checklists");
     final tas= task.copyWith(content: updatedMeta);
     Logger().e("Updated task after deletion: ${tas.content.checkLists.length} checklists");
     return tas;
  }));
  final result = await deleteChecklistUseCase(
    ChecklistParams(
      teamId: event.teamId,
      taskId: event.taskId,
      checkId: event.checkId,
      name: '',
      isCompleted: false,
    ),
  );
}catch (e) {
      emit(state.copyWith(status: TaskStatus.ErrorUpdate, errorMessage: "$e + error occurred"));
    }
  }

  void _updateMembers(UpdateMember event, Emitter<GetTaskState> emit) async {
    try {
      _updatedMember(event, emit);
      final result = await updateMembersUseCase(event.fields);


    } catch (e) {
      emit(state.copyWith(status: TaskStatus.error, errorMessage: "$e"));
    }
  }

  void _updatedMember(UpdateMember event, Emitter<GetTaskState> emit) {
    if (event.fields.memberStatus!){
      final updatedTasks = state.tasks.map((task) {
        if (task.meta.id == event.fields.taskId) {
          // Update the task's assignToMembers
          final updatedMeta = task.meta.copyWith(
            assignToImages: [ ...task.meta.assignToMembers, event.fields.member!],
          );
          return task.copyWith(meta: updatedMeta); // Return a new task with the updated meta
        }
        return task; // Keep the other tasks unchanged
      }).toList();

      emit(state.copyWith(
        task: updatedTasks.firstWhere((task) => task.meta.id == event.fields.taskId, ),
        status: TaskStatus.success, // Indicating success state
        tasks: updatedTasks, // Updated task list
        clonetasks: updatedTasks, // If you need to update this as well
      ));




    }else{

      final updatedTasks = state.tasks.map((task) {
        if (task.meta.id == event.fields.taskId) {
          // Update the task's assignToMembers
          final updatedMeta = task.meta.copyWith(
            assignToImages: task.meta.assignToMembers.where((member) => member.user.id != event.fields.member!.user.id).toList(),
          );
          return task.copyWith(meta: updatedMeta); // Return a new task with the updated meta
        }
        return task; // Keep the other tasks unchanged
      }).toList();

      emit(state.copyWith(
        task: updatedTasks.firstWhere((task) => task.meta.id == event.fields.taskId, ),
        status: TaskStatus.success, // Indicating success state
        tasks: updatedTasks, // Updated task list
        clonetasks: updatedTasks, // If you need to update this as well
      ));


    }
  }



  void deleteTask(DeleteTask event, Emitter<GetTaskState> emit) async {
    try {

      // remove the task from the state before calling the use case
      final updatedTasks = state.tasks.where((task) => task.meta.id != event.id.taskId).toList();
      emit(state.copyWith(
        tasks: updatedTasks,
        clonetasks: updatedTasks,
        status: TaskStatus.success, // Indicating success state
      ));
      final result = await deleteTaskUseCase(event.id);
      emit(_mapFailureOrSuccess(result,emit,(task){
        return state.copyWith(status: TaskStatus.success);
      }));
   //   final updatedTasks =UnmodifiableListView( [...state.tasks.where((task) => task.meta.id != event.id.taskId)]);

     // checkState(emit, updatedTasks);
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.error, errorMessage: "An error occurred"));
    }
  }

  void _initTasks(initTasks event, Emitter<GetTaskState> emit) {
    emit(state.copyWith(clonetasks: event.tasksInit,status: TaskStatus.success,));
  }  void _initTask(initTask event, Emitter<GetTaskState> emit) {
    emit(state.copyWith(task: event.tasksInit,status: TaskStatus.success,));
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


        emit(state.copyWith(

          clonetasks: r,
          tasks: r,

          status: TaskStatus.success,
        ));

      }
    } catch (error) {
      Logger().e("Error: $error");
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
    try {
      emit (state.copyWith(status: TaskStatus.Changed));
      log("${event.isCompleted.status} isCompleted");

      // Update the task list before calling the use case
      final updatedTasks = state.tasks.map((task) {

        if (task.meta.id == event.isCompleted.taskId) {
          // Update the task's status
          final updatedMeta = task.meta.copyWith(status: event.isCompleted.status);
          log(updatedMeta.status.toString() + " updated status");

          return task.copyWith(meta: updatedMeta); // Return a new task with the updated meta
        }
        return task; // Keep the other tasks unchanged
      }).toList();

      // Emit the updated task list in the state
      emit(state.copyWith(
        task: updatedTasks.firstWhere((task) => task.meta.id == event.isCompleted.taskId, ),
        status: TaskStatus.success, // Indicating success state
        tasks: updatedTasks, // Updated task list
        clonetasks: updatedTasks, // If you need to update this as well
      ));
log("Updated tasks: ${updatedTasks.length} tasks");
      // Now call the use case to update the task status in the database
      await UpdateTaskStatusUseCase(event.isCompleted);

    } catch (e) {
          Logger().e("Error: $e");
      emit(state.copyWith(status: TaskStatus.error, errorMessage: "An error occurred"));
    }
  }

  void _taskUpdateTime(UpdateTimeline event, Emitter<GetTaskState> emit) async {
    try{
      log("${event.timeline}timeline");

    final updt=  UpdateTimelineFun(event, emit,);
      emit(state.copyWith(
        status: TaskStatus.success, // Indicating success state
        tasks: updt, // Updated task list
        clonetasks: updt, // If you need to update this as well
      ));
      await updateTaskTimelineUseCase(event.timeline);
      log(state.status.toString());
    }
    catch(e){
      log(e.toString());
      emit(state.copyWith(status: TaskStatus.error, errorMessage: "An error occurred"));
    }

  }



                          UpdateTimelineFun(UpdateTimeline event, Emitter<GetTaskState> emit,) {
    final updatedTasks = state.tasks.map((task) {

      if (task.meta.id == event.timeline.taskId) {
        // Update the task's status
        final updatedMeta = task.meta.copyWith(startDate: event.timeline.startDate,deadline: event.timeline.Deadline);
      final pp= task.copyWith(meta: updatedMeta); // Return a new task with the updated meta
emit(state.copyWith(task: pp));
 return pp; // Return the updated task
      }
      return task; // Keep the other tasks unchanged
    }).toList();
    return updatedTasks;

  }








  void _CreateTask(CreateTask event, Emitter <GetTaskState> emit) async {
    try {
      final tempTask = Tasks.fromName(event.task.name, event.task.status);

      // 2. Optimistically add to the list
      final updatedTasks = [tempTask, ...state.tasks];
      emit(state.copyWith(tasks: updatedTasks, ));

      // 3. Call the use case
      final result = await addTaskUseCase(event.task);
      emit(_mapFailureOrSuccess(result,emit,
              onError: (){
                state.copyWith(
                  tasks: state.tasks.where((t) => t != tempTask).toList(),
                  status: TaskStatus.error,
                );
              },

              (task){
        final newTasks = updatedTasks.map((t) {
          if (t.meta.name == tempTask.meta.name) {
            return task;
          }
          return t;
        }).toList();
        return state.copyWith(tasks:newTasks, status: TaskStatus.success);
      }));



    } catch (error) {
      emit(state.copyWith(status: TaskStatus.ErrorUpdate, errorMessage: "$error + error occurred"));

    }
  }
  GetTaskState _mapFailureOrSuccess<T>(
      Either<Failure, T> failureOrChecklist, Emitter<GetTaskState> emit, Function(T) onSuccess,{ Function()? onError}) {
    return failureOrChecklist.fold(
          (failure) {
            if (onError!=null){
             return  onError();
            }
            else {
              return state.copyWith(status: TaskStatus.error, );
            }},
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
 GetTaskState _mapSuccess(
     Emitter<GetTaskState> emit,
    String id,
  Tasks  Function(Tasks) onSuccess) {
  final updatedTasks = state.tasks.map((task) {

    if (task.meta.id == id) {
      // Update the task's status


     return  onSuccess(task); // Return a new task with the updated meta
    }

    return task; // Keep the other tasks unchanged
  }).toList();

  Logger().d("Updated tasks: ${updatedTasks.length} tasks after success");
  // Emit the updated task list in the state
return state.copyWith(
    task: updatedTasks.firstWhere((task) => task.meta.id == id, ),
    status: TaskStatus.success, // Indicating success state
    tasks: updatedTasks, // Updated task list
    clonetasks: updatedTasks, // If you need to update this as well
  );

  }}