part of 'get_task_bloc.dart';
enum TaskStatus { initial, success, error,Changed,Loading,SuccessCheck,ErrorUpdate }
class GetTaskState extends Equatable {
  final TaskStatus status;
  final List<Tasks> Todotasks;
  final List<Tasks> InProgresstasks;
  final List<Tasks> Completedtasks;
  final List<Tasks> Delayedtasks;
  final List<Tasks> clonetasks;

  final String errorMessage;
  final Tasks? task;
  final Uint8List? image;



  const GetTaskState( { this.status = TaskStatus.initial, this.errorMessage = "",
    this.clonetasks=const [],
    this.task,
    this.image,
    this.Todotasks=const [],

    this.InProgresstasks=const [],
    this.Completedtasks=const [],
    this.Delayedtasks=const [],



  }
      );

  GetTaskState copyWith({
    Tasks? task,
    List<Tasks>? Todotasks,
    List<Tasks>? InProgresstasks,
    List<Tasks>? Completedtasks,
    List<Tasks>? Delayedtasks,



    List<Tasks>? clonetasks,

    TaskStatus? status,
    String? errorMessage,
    Uint8List? image,
  }) {
    return GetTaskState(
      task: task ?? this.task,

      Todotasks: Todotasks ?? this.Todotasks,
      InProgresstasks: InProgresstasks ?? this.InProgresstasks,
      Completedtasks: Completedtasks ?? this.Completedtasks,
      Delayedtasks: Delayedtasks ?? this.Delayedtasks,

      clonetasks: clonetasks ?? this.clonetasks,


      status: status ?? this.status,
      image: image ?? this.image,
      errorMessage: errorMessage ?? this.errorMessage,

    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [task,
    Todotasks,
    InProgresstasks,
    Completedtasks,
    Delayedtasks,


    status, errorMessage,clonetasks,image];

}

class GetTaskInitial extends GetTaskState {
  const GetTaskInitial();

  @override
  List<Object> get props => [];
}


