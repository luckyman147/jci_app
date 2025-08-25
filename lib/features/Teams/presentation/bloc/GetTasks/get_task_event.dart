part of 'get_task_bloc.dart';

abstract class GetTaskEvent extends Equatable {
  const GetTaskEvent();
}

class GetTasks extends GetTaskEvent {
  final String id;
  final TaskCompletionStatus filter;
  const GetTasks({required this.id,required this.filter});
  @override
  List<Object> get props => [id,filter];
}

class GetTaskById extends GetTaskEvent {
 final TaskIdParams ids;
  const GetTaskById({required this.ids,});
  @override
  List<Object> get props => [ids];
}
class CreateTask extends GetTaskEvent {
  final AddTaskParams task;
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


class resetevent extends GetTaskEvent {
  @override
  List<Object> get props => [];
}





class UpdateTimeline extends GetTaskEvent {
  final UpdateTaskParams timeline;

  const UpdateTimeline(this.timeline, );
  @override
  List<Object> get props => [timeline];
}







class UpdateStatus extends GetTaskEvent {
  final UpdateTaskParams isCompleted;

  const UpdateStatus(this.isCompleted,);
  @override
  List<Object> get props => [isCompleted,];
}
class initCompletedList extends GetTaskEvent {
  final List<Map<String,dynamic>> IsCompleted;

  final String id;
  const initCompletedList(this.IsCompleted, this.id);
  @override
  List<Object> get props => [IsCompleted];
}
class initTasks extends GetTaskEvent {
  final List<Tasks>tasksInit;
  const initTasks(this.tasksInit);
  @override
  List<Object> get props => [tasksInit];
}
class initTask extends GetTaskEvent {
  final Tasks tasksInit;
  const initTask(this.tasksInit);
  @override
  List<Object> get props => [tasksInit];
}
class DeleteTask extends GetTaskEvent {
  final AddTaskParams id;
  const DeleteTask(this.id);
  @override
  List<Object> get props => [id];
}

class UpdateTaskNameEvent extends GetTaskEvent {
final UpdateTaskParams fields;
  const UpdateTaskNameEvent(this.fields);
  @override
  List<Object> get props => [fields];
}class UpdateTaskDescriptionEvent extends GetTaskEvent {
final UpdateTaskParams fields;
  const UpdateTaskDescriptionEvent(this.fields);
  @override
  List<Object> get props => [fields];
}
class UpdateMemberRoleEvent extends GetTaskEvent {
  final UpdateTaskParams fields;

  const UpdateMemberRoleEvent(this.fields, );
  @override
  List<Object> get props => [fields,];
}
class UpdateMember extends GetTaskEvent {
  final UpdateTaskParams fields;
  final TeamUser Member;
  const UpdateMember(this.fields, this.Member);
  @override
  List<Object> get props => [fields, Member];
}
class AddInitCommentEvent extends GetTaskEvent {
  final TaskComment? comment;
  const AddInitCommentEvent(this.comment);
  @override
  List<Object> get props => [];
}


class AddCommentIdEvent extends GetTaskEvent {
  final String commentId;
  final String taskId;
  const AddCommentIdEvent(this.commentId, this.taskId);
  @override
  List<Object> get props => [commentId,taskId];
}

class init_members extends GetTaskEvent {
  final List<Map<String,dynamic>> members;
  final String id;
  const init_members(this.members, this.id);
  @override
  List<Object> get props => [members,id];
}


class AddChecklistEvent extends GetTaskEvent {
  final String teamId;
  final String taskId;
  final String name;
  AddChecklistEvent(this.teamId, this.taskId, this.name);

  @override
  List<Object?> get props => [teamId, taskId, name];
}

class UpdateChecklistStatusEvent extends GetTaskEvent {
  final String teamId;
  final String taskId;
  final String checkId;
  final bool isCompleted;

  UpdateChecklistStatusEvent(this.teamId, this.taskId, this.checkId, this.isCompleted);
  @override
  List<Object?> get props => [teamId, taskId, checkId, isCompleted];
}

class UpdateChecklistNameEvent extends GetTaskEvent {
  final ChecklistParams checklistParams;
  UpdateChecklistNameEvent( this.checklistParams);
  @override
  List<Object?> get props => [checklistParams];
}

class DeleteChecklistEvent extends GetTaskEvent {
  final String teamId;
  final String taskId;
  final String checkId;
  DeleteChecklistEvent(this.teamId, this.taskId, this.checkId);
  @override
  List<Object?> get props => [teamId, taskId, checkId];
}
