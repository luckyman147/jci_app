import 'package:dartz/dartz.dart';
import 'package:jci_app/core/usescases/usecase.dart';
import 'package:jci_app/features/common/enums/PrivacyType.dart';

import '../../../../core/error/Failure.dart';
import '../../presentation/enum/ProjectCreationStep.dart';
import '../entities/Project.dart';
import '../repositories/projectRepositories.dart';

class CreateProjectUseCase {
  final ProjectRepository _projectRepository;

  CreateProjectUseCase(this._projectRepository);

  Stream<Either<Failure, ProjectCreationStatus>> call(Project project) async* {
    yield* _projectRepository.createProject(project);
  }
}
class UpdateProjectUseCase extends UseCase<Unit,Project> {
  final ProjectRepository _projectRepository;

  UpdateProjectUseCase(this._projectRepository);

  Future<Either<Failure, Unit>> call(Project project) async{
   return await _projectRepository.updateProject(project);
  }
}

class GetProjectByIdUseCase extends UseCase<Project, String> {
  final ProjectRepository _projectRepository;

  GetProjectByIdUseCase(this._projectRepository);

  Future<Either<Failure, Project>> call(String id) async {
    return await _projectRepository.getProjectById(id);
  }
}
class GetAllProjectsUseCase extends UseCase<List<Project>, PrivacyType> {
  final ProjectRepository _projectRepository;

  GetAllProjectsUseCase(this._projectRepository);

  Future<Either<Failure, List<Project>>> call(PrivacyType params) async {
    return await _projectRepository.getAllProjects(params);
  }
}
class ClearProjectUseCase extends UseCase<Unit, NoParams> {
  final ProjectRepository _projectRepository;

  ClearProjectUseCase(this._projectRepository);

  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await _projectRepository.clearDraft();
  }
}
class GetDraftProjectUseCase extends UseCase<Project, NoParams> {
  final ProjectRepository _projectRepository;

  GetDraftProjectUseCase(this._projectRepository);

  Future<Either<Failure, Project>> call(NoParams params) async {
    return await _projectRepository.getDraft();
  }
}
class SaveDraftProjectUseCase extends UseCase<Unit, Project> {
  final ProjectRepository _projectRepository;

  SaveDraftProjectUseCase(this._projectRepository);

  Future<Either<Failure, Unit>> call(Project project) async {
    return await _projectRepository.saveDraft(project);
  }
}
class DeleteProjectUseCase extends UseCase<Unit, String> {
  final ProjectRepository _projectRepository;

  DeleteProjectUseCase(this._projectRepository);

  Future<Either<Failure, Unit>> call(String id) async {
    return await _projectRepository.deleteProject(id);
  }
}
class deleteTeamFromProjectUseCase extends UseCase<Unit, ParamIds> {
  final ProjectRepository _projectRepository;

  deleteTeamFromProjectUseCase(this._projectRepository);

  Future<Either<Failure, Unit>> call(ParamIds ids) async {
    return await _projectRepository.deleteTeamFromProject(ids.projectId,ids.teamId);
  }
}
class ParamIds{
  final String projectId;
  final String teamId;

  ParamIds({required this.projectId, required this.teamId});
}