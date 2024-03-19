part of 'task_visible_bloc.dart';

abstract class TaskVisibleEvent extends Equatable {
  const TaskVisibleEvent();
}
class ToggleTaskVisible extends TaskVisibleEvent {
  final bool WillVisible;
  ToggleTaskVisible(this.WillVisible);
  @override
  List<
      Object> get props => [WillVisible];
}

class resetTaskVisible extends TaskVisibleEvent {
  @override
  List<Object> get props => [];
}
class FullTasks extends TaskVisibleEvent {
  final List<Tasks> tasks;
  FullTasks(this.tasks);
  @override
  List<Object> get props => [tasks];
}
class AddedTaskedEvent extends TaskVisibleEvent {
  final Tasks task;
  AddedTaskedEvent(this.task);
  @override
  List<Object> get props => [task];
}