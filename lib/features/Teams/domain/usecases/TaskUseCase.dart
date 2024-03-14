import 'package:dartz/dartz.dart';
import 'package:jci_app/features/Teams/domain/entities/Task.dart';
import 'package:jci_app/features/Teams/domain/repository/TaskRepo.dart';
import 'package:jci_app/features/Teams/domain/repository/TeamRepo.dart';

import '../../../../core/error/Failure.dart';
import '../../../../core/usescases/usecase.dart';
import '../entities/Checklist.dart';

class GetTasksOfTeamUseCase extends UseCase<List<Tasks>, String> {
  final TaskRepo _taskRepository;

  GetTasksOfTeamUseCase(this._taskRepository);

  @override
  Future<Either<Failure, List<Tasks>>> call(String params) {
    return _taskRepository.getTasksOfTeam(params);
  }
}
class GetTasksByIdUseCase extends UseCase<Tasks, Map<String, String>> {
  final TaskRepo _taskRepository;

  GetTasksByIdUseCase(this._taskRepository);

  @override
  Future<Either<Failure, Tasks>> call(Map<String, String> params) {
    return _taskRepository.getTasksById(params['id']!, params['taskid']!);
  }
}
class AddTaskUseCase extends UseCase<Unit, Map<String, dynamic>> {
  final TaskRepo _taskRepository;

  AddTaskUseCase(this._taskRepository);

  @override
  Future<Either<Failure, Unit>> call(Map<String, dynamic> params) {
    return _taskRepository.addTask(params['Teamid']!, params['task']! as Tasks);
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
class DeleteTaskUseCase extends UseCase<Unit, Map<String, String>> {
  final TaskRepo _taskRepository;

  DeleteTaskUseCase(this._taskRepository);

  @override
  Future<Either<Failure, Unit>> call(Map<String, String> params) {
    return _taskRepository.deleteTask(params['id']!, params['taskid']!);
  }
}
class AddChecklistUseCase extends UseCase<Unit, Map<String, dynamic>> {
  final TaskRepo _taskRepository;

  AddChecklistUseCase(this._taskRepository);

  @override
  Future<Either<Failure, Unit>> call(Map<String, dynamic> params) {
    return _taskRepository.addChecklist(params['id']!, params['taskid']!, params['checklist']!);
  }
}
class UpdateChecklistUseCase extends UseCase<Unit, Map<String, dynamic>> {
  final TaskRepo _taskRepository;

  UpdateChecklistUseCase(this._taskRepository);

  @override
  Future<Either<Failure, Unit>> call(Map<String, dynamic> params) {
    return _taskRepository.updateChecklist(params['id']!, params['taskid']!, params['checklistid']!, params['checklist']! as CheckList);
  }
}
class DeleteChecklistUseCase extends UseCase<Unit, Map<String, String>> {
  final TaskRepo _taskRepository;

  DeleteChecklistUseCase(this._taskRepository);

  @override
  Future<Either<Failure, Unit>> call(Map<String, String> params) {
    return _taskRepository.deleteChecklist(params['id']!, params['taskid']!, params['checklistid']!);
  }
}

