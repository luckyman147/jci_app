part of 'task_visible_bloc.dart';

 class TaskVisibleState extends Equatable {
   final bool WillAdded;
   final List<Tasks> tasks;


   TaskVisibleState(this.WillAdded, this.tasks,);

   TaskVisibleState copyWith({
    bool? WillAdded,
    List<Tasks>? tasks,
   }) {
   return TaskVisibleState(
   WillAdded ?? this.WillAdded,
    tasks ?? this.tasks,

   );
   }

   @override
   // TODO: implement props
   List<Object?> get props => [WillAdded,tasks];
   }


class TaskVisibleInitial extends TaskVisibleState {
  TaskVisibleInitial(super.WillAdded, super.tasks);

  @override
  List<Object> get props => [];
}
