part of 'taskfilter_bloc.dart';

abstract class TaskfilterEvent extends Equatable {
  const TaskfilterEvent();
}
class TaskfilterSelected extends TaskfilterEvent {
  final TaskCompletionStatus selectedFilter;
  const TaskfilterSelected(this.selectedFilter);
  @override
  List<Object> get props => [selectedFilter];
}
class filterTask extends TaskfilterEvent {
  final List<Tasks> tasks;
  const filterTask(this.tasks);
  @override
  List<Object> get props => [tasks];
}