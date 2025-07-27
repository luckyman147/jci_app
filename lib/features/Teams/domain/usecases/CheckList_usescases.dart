import 'package:dartz/dartz.dart';

import '../../../../core/error/Failure.dart';
import '../../../../core/usescases/usecase.dart';
import '../dto/TaskIdParams.dart';
import '../entities/Checklist.dart';
import '../repository/Tasks/CheckListRepository.dart';

class AddChecklistUseCase extends UseCase<CheckList, ChecklistParams> {
  final ChecklistRepository repo;
  AddChecklistUseCase(this.repo);

  @override
  Future<Either<Failure, CheckList>> call(ChecklistParams params) {
    return repo.addChecklist(params.teamId,params.taskId, params.name);
  }
}

class UpdateChecklistStatusUseCase extends UseCase<Unit, ChecklistParams> {
  final ChecklistRepository repo;
  UpdateChecklistStatusUseCase(this.repo);

  @override
  Future<Either<Failure, Unit>> call(ChecklistParams params) {
    return repo.updateChecklistStatus(params.teamId,params.taskId, params.checkId, params.isCompleted);
  }
}

class UpdateChecklistUseCase extends UseCase<Unit, ChecklistUpdateParams> {
  final ChecklistRepository repo;
  UpdateChecklistUseCase(this.repo);

  @override
  Future<Either<Failure, Unit>> call(ChecklistUpdateParams params) {
    return repo.updateChecklist(params.teamId, params.taskId, params.checkId, params.checklist);
  }
}

class UpdateChecklistNameUseCase extends UseCase<Unit, ChecklistParams> {
  final ChecklistRepository repo;
  UpdateChecklistNameUseCase(this.repo);

  @override
  Future<Either<Failure, Unit>> call(ChecklistParams params) {
    return repo.updateChecklistName(params.teamId,params.taskId, params.checkId, params.name);
  }
}
class FetchChecklistUseCase extends UseCase<List<CheckList>, TaskIdParams> {
  final ChecklistRepository repo;
  FetchChecklistUseCase(this.repo);

  @override
  Future<Either<Failure, List<CheckList>>> call(TaskIdParams params) {
    return repo.fetchChecklists(params.teamId, params.taskId);
  }
}

class DeleteChecklistUseCase extends UseCase<Unit, ChecklistParams> {
  final ChecklistRepository repo;
  DeleteChecklistUseCase(this.repo);

  @override
  Future<Either<Failure, Unit>> call( ChecklistParams params) {
    return repo.deleteChecklist( params.teamId, params.taskId, params.checkId);
  }
}
