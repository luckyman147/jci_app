part of 'get_task_bloc.dart';

abstract class GetTaskEvent extends Equatable {
  const GetTaskEvent();
}

class GetTasks extends GetTaskEvent {
  final String id;
  final TaskFilter filter;
  GetTasks({required this.id,required this.filter});
  @override
  List<Object> get props => [id,filter];
}
class AddCommentEvent extends GetTaskEvent {
  final CommentInput comment;
  AddCommentEvent(this.comment);
  @override
  List<Object> get props => [comment];
}
class GetTaskById extends GetTaskEvent {
 final inputFields ids;
  GetTaskById({required this.ids,});
  @override
  List<Object> get props => [ids];
}
class CreateTask extends GetTaskEvent {
  final inputFields task;
  CreateTask(this.task);
  @override
  List<Object> get props => [task];
}
class GetChecklist  extends GetTaskEvent {
  final List<Map<String, dynamic>> checklist;
  GetChecklist(this.checklist);
  @override
  List<Object> get props => [checklist];
}

class AddCheckList extends GetTaskEvent {
  final  CheckInputFields checklist;

  AddCheckList(this.checklist,);
  @override
  List<Object> get props => [checklist];
}
class resetevent extends GetTaskEvent {
  @override
  List<Object> get props => [];
}





class UpdateTimeline extends GetTaskEvent {
  final inputFields timeline;

  UpdateTimeline(this.timeline, );
  @override
  List<Object> get props => [timeline];
}







class UpdateChecklistStatus extends GetTaskEvent {
  final CheckInputFields checklist;


  UpdateChecklistStatus(this.checklist);
  @override
  List<Object> get props => [checklist];
}
class UpdateStatus extends GetTaskEvent {
  final inputFields isCompleted;
  final int index;
  UpdateStatus(this.isCompleted, this.index);
  @override
  List<Object> get props => [isCompleted,index];
}
class initCompletedList extends GetTaskEvent {
  final List<Map<String,dynamic>> IsCompleted;

  final String id;
  initCompletedList(this.IsCompleted, this.id);
  @override
  List<Object> get props => [IsCompleted];
}
class initTasks extends GetTaskEvent {
  final List<Map<String, dynamic>>tasksInit;
  initTasks(this.tasksInit);
  @override
  List<Object> get props => [tasksInit];
}
class DeleteTask extends GetTaskEvent {
  final String id;
  DeleteTask(this.id);
  @override
  List<Object> get props => [id];
}
class DeleteChecklist extends GetTaskEvent {
  final String id;
  final String checklistId;
  DeleteChecklist(this.id, this.checklistId);
  @override
  List<Object> get props => [id,checklistId];
}
class UpdateTaskName extends GetTaskEvent {
final inputFields fields;
  UpdateTaskName(this.fields);
  @override
  List<Object> get props => [fields];
}
class UpdateMember extends GetTaskEvent {
  final inputFields fields;
  UpdateMember(this.fields);
  @override
  List<Object> get props => [fields];
}
class init_members extends GetTaskEvent {
  final List<Map<String,dynamic>> members;
  final String id;
  init_members(this.members, this.id);
  @override
  List<Object> get props => [members,id];
}
class UpdateFile extends GetTaskEvent {
  final inputFields fields;

  UpdateFile(this.fields, );
  @override
  List<Object> get props => [fields];
}
class DeleteFileEvent extends GetTaskEvent {
  final inputFields fields;

  DeleteFileEvent(this.fields, );
  @override
  List<Object> get props => [fields];
}
class UpdateChecklistName extends GetTaskEvent {
  final CheckInputFields fields;

  UpdateChecklistName(this.fields, );
  @override
  List<Object> get props => [fields];
}