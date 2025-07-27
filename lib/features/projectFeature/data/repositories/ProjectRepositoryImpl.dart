import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Exception.dart';

import 'package:jci_app/core/error/Failure.dart';

import 'package:jci_app/features/Teams/domain/entities/Team/Team.dart';

import 'package:jci_app/features/common/enums/PrivacyType.dart';
import 'package:jci_app/features/projectFeature/data/models/ProjectModel.dart';

import 'package:jci_app/features/projectFeature/domain/entities/Project.dart';

import '../../../../core/Handlers/Handler.dart';
import '../../domain/repositories/projectRepositories.dart';
import '../../presentation/enum/ProjectCreationStep.dart';
import '../datasources/ProjectLocalDataSources.dart';
import '../datasources/ProjectRemoteDataSources.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSources remoteDataSource;
  final ProjectLocalDataSources localDataSource;
final Handler<ProjectCreationStatus> handler;
final Handler<Project> projectHandler;
final Handler<Unit> unitHandler;
final Handler<List<Project>> projectsHandler;


  ProjectRepositoryImpl({
    required this.handler,
    required this.unitHandler,
    required this.projectHandler,
    required this.projectsHandler,
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Stream<Either<Failure, ProjectCreationStatus>> createProject(Project project, )async* {
    yield*  handler.handleSTream(onCall: ()async*{
      final result=  remoteDataSource.createProject(ProjectModel.fromEntity(project));
      yield* result;

    }, onError: (e){
      if (e is Exception) {
        return e.get_failure;
      } else {
        throw e;
      }
    });

  }

  @override
  Future<Either<Failure, Unit>> deleteProject(String projectId) async{

    return await unitHandler.handle(onCall: () async {
      final result = await remoteDataSource.deleteProject(projectId);
      return result;
    }, onError: (e) {
      if (e is Exception) {
        return e.get_failure;
      } else {
        throw e;
      }
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteTeamFromProject(String projectId, String teamId) async{
    return await unitHandler.handle(onCall: () async {
      final result = await remoteDataSource.deleteTeamFromProject(projectId, teamId);
      return result;
    }, onError: (e) {
      if (e is Exception) {
        return e.get_failure;
      } else {
        throw e;
      }
    });
  }

  @override
  Future<Either<Failure, List<Project>>> getAllProjects(PrivacyType privacy)async {
    return await projectsHandler.handle(onCall: () async {
      final resultcached = await localDataSource.getAllProjects(privacy);
      if (resultcached!=null&& resultcached.isNotEmpty) {
        return resultcached;
      }

      final result = await remoteDataSource.getAllProjects(privacy);
      return result.map((project) => ProjectModel.fromEntity(project)).toList();
    }, onError: (e) {
      if (e is Exception) {
        return e.get_failure;
      } else {
        throw e;
      }
    });
  }

  @override
  Future<Either<Failure, Project>> getProjectById(String projectId)async {
    return await projectHandler.handle(onCall: () async {
      final cachedProject = await localDataSource.getProjectById(projectId);
      if (cachedProject != null) {
        return ProjectModel.fromEntity(cachedProject);
      }
      final result = await remoteDataSource.getProjectById(projectId);
      return ProjectModel.fromEntity(result);
    }, onError: (e) {
      if (e is Exception) {
        return e.get_failure;
      } else {
        throw e;
      }
    });
  }

  @override
  Future<Either<Failure, Unit>> updateProject(Project project)async {
    return await unitHandler.handle(onCall: () async {
      final result = await remoteDataSource.updateProject(ProjectModel.fromEntity(project));
      return result;
    }, onError: (e) {
      if (e is Exception) {
        return e.get_failure;
      } else {
        throw e;
      }
    });
  }

  @override
  Future<Either<Failure, Project>> getDraft() async{
    return await projectHandler.handle(onCall: () async {
      final cachedProject = await localDataSource.getDraft();
      if (cachedProject != null) {
        return ProjectModel.fromEntity(cachedProject);
      }
      throw Exception('No draft found');

    }, onError: (e) {
      if (e is Exception) {
        return e.get_failure;
      } else {
        throw e;
      }
    });

  }

  @override
  Future<Either<Failure, Unit>> saveDraft(Project project)async {
    return await unitHandler.handle(onCall: () async {
      await localDataSource.addProjectDraft(ProjectModel.fromEntity(project));
      return unit;
    }, onError: (e) {
      if (e is Exception) {
        return e.get_failure;
      } else {
        throw e;
      }
    });
  }

  @override
  Future<Either<Failure, Unit>> clearDraft() async{
    return await unitHandler.handle(onCall: () async {
      await localDataSource.Cleardraft();
      return unit;
    }, onError: (e) {
      if (e is Exception) {
        return e.get_failure;
      } else {
        throw e;
      }
    });
  }


}