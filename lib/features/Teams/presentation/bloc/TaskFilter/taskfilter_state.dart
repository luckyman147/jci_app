part of 'taskfilter_bloc.dart';

 class TaskfilterState extends Equatable {
  final TaskCompletionStatus selectedFilter;
  final List<Tasks> tasks;
  const TaskfilterState({this.selectedFilter=TaskCompletionStatus.Todo,this.tasks=const[]});
  TaskfilterState copyWith({TaskCompletionStatus? selectedFilter,List<Tasks>? tasks}) {
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
