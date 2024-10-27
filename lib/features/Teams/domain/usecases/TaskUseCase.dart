import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:jci_app/features/Teams/domain/entities/Task.dart';
import 'package:jci_app/features/Teams/domain/entities/TaskFile.dart';
import 'package:jci_app/features/Teams/domain/repository/TaskRepo.dart';
import 'package:jci_app/features/Teams/domain/repository/TeamRepo.dart';

import '../../../../core/error/Failure.dart';
import '../../../../core/usescases/usecase.dart';
import '../../../auth/domain/entities/Member.dart';
import '../entities/Checklist.dart';

class GetTasksOfTeamUseCase extends UseCase<List<Tasks>, String> {
  final TaskRepo _taskRepository;

  GetTasksOfTeamUseCase(this._taskRepository);

  @override
  Future<Either<Failure, List<Tasks>>> call(String params) {
    return _taskRepository.getTasksOfTeam(params);
  }
}
class GetTasksByIdUseCase extends UseCase<Tasks, inputFields> {
  final TaskRepo _taskRepository;

  GetTasksByIdUseCase(this._taskRepository);

  @override
  Future<Either<Failure, Tasks>> call(params) {
    return _taskRepository.getTasksById(params.teamid!, params.taskid);
  }
}
class AddTaskUseCase extends UseCase<Tasks, inputFields> {
  final TaskRepo _taskRepository;

  AddTaskUseCase(this._taskRepository);

  @override
  Future<Either<Failure, Tasks>> call( params) {
    return _taskRepository.addTask(params.teamid!, params.name!);
  }
}
class UpdateTaskUseCase extends UseCase<Unit, Map<String, dynamic>> {
  final TaskRepo _taskRepository;

  UpdateTaskUseCase(this._taskRepository);

  @override
  Future<Either<Failure, Unit>> call(Map<String, dynamic> params) {
    return _taskRepository.updateTask(params['id']!, params['task']! as Tasks);
  }
}
class DeleteTaskUseCase extends UseCase<Unit, String> {
  final TaskRepo _taskRepository;

  DeleteTaskUseCase(this._taskRepository);

  @override
  Future<Either<Failure, Unit>> call(String params) {
    return _taskRepository.deleteTask(params);
  }
}
class AddChecklistUseCase extends UseCase<CheckList,CheckInputFields> {
  final TaskRepo _taskRepository;

  AddChecklistUseCase(this._taskRepository);

  @override
  Future<Either<Failure, CheckList>> call( params) {
    return _taskRepository.addChecklist( params.taskid!, params.name!);
  }
}
class UpdateChecklistUseCase extends UseCase<Unit, CheckInputFields> {
  final TaskRepo _taskRepository;

  UpdateChecklistUseCase(this._taskRepository);

  @override
  Future<Either<Failure, Unit>> call( params) {
    return _taskRepository.updateChecklist(params.teamid!, params.taskid!, params.checkid ,params.checklist!);
  }
}
class DeleteChecklistUseCase extends UseCase<Unit, String> {
  final TaskRepo _taskRepository;

  DeleteChecklistUseCase(this._taskRepository);

  @override
  Future<Either<Failure, Unit>> call( String params) {
    return _taskRepository.deleteChecklist( params);
  }
}
class UpdateIsCompletedUseCases extends UseCase<Unit,inputFields> {
  final TaskRepo _taskRepository;

  UpdateIsCompletedUseCases(this._taskRepository);

  @override
  Future<Either<Failure, Unit>> call( params) {
    return _taskRepository.UpdateTask(params.taskid, params.isCompleted!);
  }
}

class UpdateChecklistStatusUseCase extends UseCase<Unit, CheckInputFields> {
  final TaskRepo _taskRepository;

  UpdateChecklistStatusUseCase(this._taskRepository);

  @override
  Future<Either<Failure, Unit>> call( params) {
    return _taskRepository.UpdateChecklistStatus(params.taskid!, params.checkid, params.IsCompleted!);
  }
}
class UpdateTaskNameUseCase extends UseCase<Unit, inputFields> {
  final TaskRepo _taskRepository;

  UpdateTaskNameUseCase(this._taskRepository);

  @override
  Future<Either<Failure, Unit>> call( params) {
    return _taskRepository.UpdateTaskName(params.taskid, params.name!);
  }



}
class UpdateChecklistNameUseCase extends UseCase<Unit, CheckInputFields> {
  final TaskRepo _taskRepository;

  UpdateChecklistNameUseCase(this._taskRepository);

  @override
  Future<Either<Failure, Unit>> call( params) {
    return _taskRepository.updateChecklistName(params.taskid!, params.checkid, params.name!);
  }
}
class UpdateTaskTimelineUseCase extends UseCase<Unit, inputFields> {
  final TaskRepo _taskRepository;

  UpdateTaskTimelineUseCase(this._taskRepository);

  @override
  Future<Either<Failure, Unit>> call( params) {
    return _taskRepository.UpdateTimeline(params.taskid, params.StartDate!, params.Deadline!);
  }


}
class AddCommentUseCase extends UseCase<Unit, CommentInput> {
  final TaskRepo _taskRepository;

  AddCommentUseCase(this._taskRepository);

  @override
  Future<Either<Failure, Unit>> call( params) {
    return _taskRepository.AddComment(params.taskid!, params.comment!);
  }
}
class UpdateMembersUsecases extends UseCase<Unit, inputFields> {
  final TaskRepo _taskRepository;

  UpdateMembersUsecases(this._taskRepository);

  @override
  Future<Either<Failure, Unit>> call( params) {
    return _taskRepository.UpdateMembers(
        params.taskid, params.status! , params.memberid!);
  }
}
class UpdateFileUseCase extends UseCase<TaskFile, inputFields> {
  final TaskRepo _taskRepository;

  UpdateFileUseCase(this._taskRepository);

  @override
  Future<Either<Failure, TaskFile>> call( params) {
    return _taskRepository.UpdateFiles(params.taskid, params.file!);
  }
}
class GetFileUseCase extends UseCase<Uint8List, String> {
  final TaskRepo _taskRepository;

  GetFileUseCase(this._taskRepository);

  @override
  Future<Either<Failure, Uint8List>> call( params) {
    return _taskRepository.getFile(params);
  }
}
class DeleteFileUseCases extends UseCase<Unit, inputFields> {
  final TaskRepo _taskRepository;

  DeleteFileUseCases(this._taskRepository);

  @override
  Future<Either<Failure, Unit>> call( params) {
    return _taskRepository.DeleteFiles(params.taskid, params.fileid!);
  }
}
class inputFields{
  final String taskid;
  final String? fileid;
  final TaskFile? file;
  final String? memberid;
  final bool? status;
  final String? teamid;
  final String? name;
  final Member? member;
  final Tasks? task;
  final bool? isCompleted;
  final DateTime? StartDate;
  final DateTime? Deadline;


  inputFields( {required this.taskid, required this.file, required this.memberid, required this.status,
    required this.Deadline, required this.StartDate,
    required this.name,
    required this.task,
    required this.isCompleted,
    required this.member,

    required this.teamid, required this.fileid});
}

class CommentInput {
  final String? comment;
  final String? taskid;

  final String? commentid;
  final String? memberid;

  CommentInput({required this.comment, required this.taskid, required this.commentid, required this.memberid});


}
class CheckInputFields{
  final String? taskid;
  final String checkid;
  final String? teamid;
  final CheckList? checklist;
  final String? name;
  final bool? IsCompleted;

  CheckInputFields({required this.taskid, required this.checkid, required this.checklist, required this.name, required this.IsCompleted,
    required this.teamid});


}

