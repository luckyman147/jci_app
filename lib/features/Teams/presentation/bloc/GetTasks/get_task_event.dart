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
  final List<Tasks>tasksInit;
  const initTasks(this.tasksInit);
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
}
class UpdateMember extends GetTaskEvent {
  final UpdateTaskParams fields;
  final User Member;
  const UpdateMember(this.fields, this.Member);
  @override
  List<Object> get props => [fields, Member];
}
class init_members extends GetTaskEvent {
  final List<Map<String,dynamic>> members;
  final String id;
  const init_members(this.members, this.id);
  @override
  List<Object> get props => [members,id];
}
