part of 'get_task_bloc.dart';

abstract class GetTaskEvent extends Equatable {
  const GetTaskEvent();
}

class GetTasks extends GetTaskEvent {
  final String id;
  final TaskFilter filter;
  const GetTasks({required this.id,required this.filter});
  @override
  List<Object> get props => [id,filter];
}
class AddCommentEvent extends GetTaskEvent {
  final CommentInput comment;
  const AddCommentEvent(this.comment);
  @override
  List<Object> get props => [comment];
}
class GetTaskById extends GetTaskEvent {
 final inputFields ids;
  const GetTaskById({required this.ids,});
  @override
  List<Object> get props => [ids];
}
class CreateTask extends GetTaskEvent {
  final inputFields task;
  const CreateTask(this.task);
  @override
  List<Object> get props => [task];
}
class GetChecklist  extends GetTaskEvent {
  final List<Map<String, dynamic>> checklist;
  const GetChecklist(this.checklist);
  @override
  List<Object> get props => [checklist];
}

class AddCheckList extends GetTaskEvent {
  final  CheckInputFields checklist;

  const AddCheckList(this.checklist,);
  @override
  List<Object> get props => [checklist];
}
class resetevent extends GetTaskEvent {
  @override
  List<Object> get props => [];
}





class UpdateTimeline extends GetTaskEvent {
  final inputFields timeline;

  const UpdateTimeline(this.timeline, );
  @override
  List<Object> get props => [timeline];
}







class UpdateChecklistStatus extends GetTaskEvent {
  final CheckInputFields checklist;


  const UpdateChecklistStatus(this.checklist);
  @override
  List<Object> get props => [checklist];
}
class UpdateStatus extends GetTaskEvent {
  final inputFields isCompleted;
  final int index;
  const UpdateStatus(this.isCompleted, this.index);
  @override
  List<Object> get props => [isCompleted,index];
}
class initCompletedList extends GetTaskEvent {
  final List<Map<String,dynamic>> IsCompleted;

  final String id;
  const initCompletedList(this.IsCompleted, this.id);
  @override
  List<Object> get props => [IsCompleted];
}
class initTasks extends GetTaskEvent {
  final List<Map<String, dynamic>>tasksInit;
  const initTasks(this.tasksInit);
  @override
  List<Object> get props => [tasksInit];
}
class DeleteTask extends GetTaskEvent {
  final String id;
  const DeleteTask(this.id);
  @override
  List<Object> get props => [id];
}
class DeleteChecklist extends GetTaskEvent {
  final String id;
  final String checklistId;
  const DeleteChecklist(this.id, this.checklistId);
  @override
  List<Object> get props => [id,checklistId];
}
class UpdateTaskName extends GetTaskEvent {
final inputFields fields;
  const UpdateTaskName(this.fields);
  @override
  List<Object> get props => [fields];
}
class UpdateMember extends GetTaskEvent {
  final inputFields fields;
  const UpdateMember(this.fields);
  @override
  List<Object> get props => [fields];
}
class init_members extends GetTaskEvent {
  final List<Map<String,dynamic>> members;
  final String id;
  const init_members(this.members, this.id);
  @override
  List<Object> get props => [members,id];
}
class UpdateFile extends GetTaskEvent {
  final inputFields fields;

  const UpdateFile(this.fields, );
  @override
  List<Object> get props => [fields];
}
class DeleteFileEvent extends GetTaskEvent {
  final inputFields fields;

  const DeleteFileEvent(this.fields, );
  @override
  List<Object> get props => [fields];
}
class UpdateChecklistName extends GetTaskEvent {
  final CheckInputFields fields;

  const UpdateChecklistName(this.fields, );
  @override
  List<Object> get props => [fields];
}
class GetFileEvent extends GetTaskEvent {
  final String id;
  const GetFileEvent(this.id);
  @override
  List<Object> get props => [id];
}