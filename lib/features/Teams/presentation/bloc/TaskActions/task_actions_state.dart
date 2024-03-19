part of 'task_actions_bloc.dart';

 abstract class TaskActionsState extends Equatable {

}

class TaskActionsInitial extends TaskActionsState {
  @override
  List<Object> get props => [];
}

class ErrorMessage extends TaskActionsState {
  final String message;
  ErrorMessage({required this.message});
  @override
  List<Object> get props => [message];
}
class TaskAdded extends TaskActionsState {
  final String message;
  TaskAdded({required this.message});
  @override
  List<Object> get props => [message];
}

