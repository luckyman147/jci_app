import 'package:dartz/dartz.dart';
import 'package:jci_app/features/Teams/domain/repository/Tasks/TaskRepo.dart';

import '../../../../core/error/Failure.dart';
import '../../../../core/usescases/usecase.dart';
import '../dto/TaskIdParams.dart';
import '../entities/task/Task.dart';

class GetTasksOfTeamUseCase extends UseCase<List<Tasks>, String> {
  final TaskRepository repo;
  GetTasksOfTeamUseCase(this.repo);

  @override
  Future<Either<Failure, List<Tasks>>> call(String teamId) {
    return repo.getTasksOfTeam(teamId);
  }
}

class GetTaskByIdUseCase extends UseCase<Tasks, TaskIdParams> {
  final TaskRepository repo;
  GetTaskByIdUseCase(this.repo);

  @override
  Future<Either<Failure, Tasks>> call(TaskIdParams params) {
    return repo.getTasksById(params.teamId, params.taskId);
  }
}

class AddTaskUseCase extends UseCase<Tasks, AddTaskParams> {
  final TaskRepository repo;
  AddTaskUseCase(this.repo);

  @override
  Future<Either<Failure, Tasks>> call(AddTaskParams params) {
    return repo.addTask(params.teamId, params.name);
  }
}



class DeleteTaskUseCase extends UseCase<Unit, AddTaskParams> {
  final TaskRepository repo;
  DeleteTaskUseCase(this.repo);

  @override
  Future<Either<Failure, Unit>> call(AddTaskParams task) {
    return repo.deleteTask(task.teamId, task.name);
  }
}
class updateTaskStatusUseCase extends UseCase<Unit, UpdateTaskParams> {
  final TaskRepository repo;
  updateTaskStatusUseCase(this.repo);

  @override
  Future<Either<Failure, Unit>> call(UpdateTaskParams params) {
    return repo.updateTaskStatus(params.teamId!, params.taskId, params.status!);
  }
}
class updateTaskNameUseCase extends UseCase<Unit, UpdateTaskParams> {
  final TaskRepository repo;
  updateTaskNameUseCase(this.repo);

  @override
  Future<Either<Failure, Unit>> call(UpdateTaskParams params) {
    return repo.updateTaskName(params.teamId!, params.taskId, params.name!);
  }
}

class UpdateTaskTimeline  extends UseCase<Unit, UpdateTaskParams> {
  final TaskRepository repo;
  UpdateTaskTimeline(this.repo);

  @override
  Future<Either<Failure, Unit>> call(UpdateTaskParams params) {
    return repo.updateTimeline(params.teamId!, params.taskId, params.startDate!, params.Deadline!);
  }
}
class UpdateMembersUseCase extends UseCase<Unit, UpdateTaskParams> {
  final TaskRepository repo;
  UpdateMembersUseCase(this.repo);

  @override
  Future<Either<Failure, Unit>> call(UpdateTaskParams params) {
    return repo.updateMembers(params.teamId!, params.taskId, params.memberStatus!,params.memberId!);
  }
}
