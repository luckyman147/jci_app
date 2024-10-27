part of 'get_task_bloc.dart';
enum TaskStatus { initial, success, error,Changed,Loading,SuccessCheck,ErrorUpdate }
class GetTaskState extends Equatable {
  final TaskStatus status;
  final List<Map<String, dynamic>> tasks;
  final List<Map<String, dynamic>> clonetasks;
  final String errorMessage;
  final Uint8List? image;



  GetTaskState( {this.tasks=const [], this.status = TaskStatus.initial, this.errorMessage = "",
    this.clonetasks=const [],
    this.image,


  }
      );

  GetTaskState copyWith({





    List<Map<String, dynamic>>? tasks,
    List<Map<String, dynamic>>? clonetasks,

    TaskStatus? status,
    String? errorMessage,
    Uint8List? image,
  }) {
    return GetTaskState(



      tasks: tasks ?? this.tasks,
      clonetasks: clonetasks ?? this.clonetasks,


      status: status ?? this.status,
      image: image ?? this.image,
      errorMessage: errorMessage ?? this.errorMessage,

    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [tasks, status, errorMessage,clonetasks,image];

}

class GetTaskInitial extends GetTaskState {
  GetTaskInitial();

  @override
  List<Object> get props => [];
}

class GetTaskLoading extends GetTaskState {
  GetTaskLoading();

  @override
  List<Object> get props => [];
}
class GetTasksLoaded extends GetTaskState {

  GetTasksLoaded(
      );
  @override
  List<Object> get props => [tasks];
}
class GetTaskError extends GetTaskState {
  final String message;
  GetTaskError( {required this.message});
  @override
  List<Object> get props => [message];
}class AddTaskError extends GetTaskState {
  final String message;
  AddTaskError( {required this.message});
  @override
  List<Object> get props => [message];
}
class AddTaskMessage extends GetTaskState {
  final String task;
  AddTaskMessage({required this.task});
  @override
  List<Object> get props => [task];
}
class GetTaskByIdLoaded extends GetTaskState {
  final Tasks task;
  GetTaskByIdLoaded({required this.task});
  @override
  List<Object> get props => [task];
}

class GetTaskEmpty extends GetTaskState {
  GetTaskEmpty();

  @override
  List<Object> get props => [tasks];
}