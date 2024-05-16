part of 'taskfilter_bloc.dart';
enum TaskFilter{ All,Pending,Completed,}
 class TaskfilterState extends Equatable {
  final TaskFilter selectedFilter;
  final List<Map<String, dynamic>> tasks;
  const TaskfilterState({this.selectedFilter=TaskFilter.All,this.tasks=const[]});
  TaskfilterState copyWith({TaskFilter? selectedFilter,List<Map<String, dynamic>>? tasks}) {
    return TaskfilterState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [selectedFilter,tasks];

}

class TaskfilterInitial extends TaskfilterState {


  @override
  List<Object> get props => [];
}
