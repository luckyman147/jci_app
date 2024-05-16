part of 'taskfilter_bloc.dart';

abstract class TaskfilterEvent extends Equatable {
  const TaskfilterEvent();
}
class TaskfilterSelected extends TaskfilterEvent {
  final TaskFilter selectedFilter;
  TaskfilterSelected(this.selectedFilter);
  @override
  List<Object> get props => [selectedFilter];
}
class filterTask extends TaskfilterEvent {
  final List<Map<String, dynamic>> tasks;
  filterTask(this.tasks);
  @override
  List<Object> get props => [tasks];
}