import 'package:dartz/dartz.dart';
import 'package:jci_app/features/common/enums/PrivacyType.dart';

import '../../../../core/error/Failure.dart';

import '../../../Teams/domain/entities/Team/Team.dart';
import '../../presentation/enum/ProjectCreationStep.dart';
import '../entities/Project.dart';

abstract class ProjectRepository {
  Stream<Either<Failure, ProjectCreationStatus>> createProject(Project project,  );
  Future<Either<Failure, Unit>> updateProject(Project project);
  Future<Either<Failure, Unit>> clearDraft();
  Future<Either<Failure, Project>> getDraft();
  Future<Either<Failure, Unit>> saveDraft(Project project);
  // delete team from project
  Future<Either<Failure, Unit>> deleteTeamFromProject(String projectId, String teamId);
  Future<Either<Failure, Unit>> deleteProject(String projectId);
  Future<Either<Failure, Project>> getProjectById(String projectId);
  Future<Either<Failure, List<Project>>> getAllProjects(PrivacyType privacy);
}
