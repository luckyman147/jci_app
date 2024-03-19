part of 'get_task_bloc.dart';

abstract class GetTaskEvent extends Equatable {
  const GetTaskEvent();
}

class GetTasks extends GetTaskEvent {
  final String id;
  GetTasks({required this.id});
  @override
  List<Object> get props => [id];
}
class GetTaskById extends GetTaskEvent {
 final Map<String,String >ids;
  GetTaskById({required this.ids,});
  @override
  List<Object> get props => [ids];
}
class CreateTask extends GetTaskEvent {
  final Map<String,String > task;
  CreateTask(this.task);
  @override
  List<Object> get props => [task];
}
class resetevent extends GetTaskEvent {
  @override
  List<Object> get props => [];
}