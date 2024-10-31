part of 'get_task_bloc.dart';
enum TaskStatus { initial, success, error,Changed,Loading,SuccessCheck,ErrorUpdate }
class GetTaskState extends Equatable {
  final TaskStatus status;
  final List<Map<String, dynamic>> tasks;
  final List<Map<String, dynamic>> clonetasks;
  final String errorMessage;
  final Uint8List? image;



  const GetTaskState( {this.tasks=const [], this.status = TaskStatus.initial, this.errorMessage = "",
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
  const GetTaskInitial();

  @override
  List<Object> get props => [];
}

class GetTaskLoading extends GetTaskState {
  const GetTaskLoading();

  @override
  List<Object> get props => [];
}
class GetTasksLoaded extends GetTaskState {

  const GetTasksLoaded(
      );
  @override
  List<Object> get props => [tasks];
}
class GetTaskError extends GetTaskState {
  final String message;
  const GetTaskError( {required this.message});
  @override
  List<Object> get props => [message];
}class AddTaskError extends GetTaskState {
  final String message;
  const AddTaskError( {required this.message});
  @override
  List<Object> get props => [message];
}
class AddTaskMessage extends GetTaskState {
  final String task;
  const AddTaskMessage({required this.task});
  @override
  List<Object> get props => [task];
}
class GetTaskByIdLoaded extends GetTaskState {
  final Tasks task;
  const GetTaskByIdLoaded({required this.task});
  @override
  List<Object> get props => [task];
}

class GetTaskEmpty extends GetTaskState {
  const GetTaskEmpty();

  @override
  List<Object> get props => [tasks];
}