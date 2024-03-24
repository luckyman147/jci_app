part of 'taskfilter_bloc.dart';
enum TaskFilter{ All,Pending,Completed,}
 class TaskfilterState extends Equatable {
  final TaskFilter selectedFilter;
  const TaskfilterState({this.selectedFilter=TaskFilter.All});
  TaskfilterState copyWith({TaskFilter? selectedFilter}) {
    return TaskfilterState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [selectedFilter];

}

class TaskfilterInitial extends TaskfilterState {


  @override
  List<Object> get props => [];
}
