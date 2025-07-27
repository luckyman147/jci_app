import 'package:dartz/dartz.dart';
import 'package:jci_app/features/common/enums/PrivacyType.dart';

import '../../domain/entities/Project.dart';
import '../../service/ProjectStore.dart';
import '../models/ProjectModel.dart';

abstract class ProjectLocalDataSources {
  /// Gets all projects from local storage.
  Future<List<ProjectModel>> getAllProjects(PrivacyType privacyType);

  /// Gets a project by its ID from local storage.
  Future<ProjectModel?> getProjectById(String id);

  /// Adds a new project to local storage.
  Future<Unit> addProjectDraft(ProjectModel project);
  Future<ProjectModel?> getDraft();
  Future<Unit> Cleardraft();
  Future<Unit> cacheProject(ProjectModel project);
  Future<Unit> cacheProjects(List<ProjectModel> projects);

}
class ProjectLocalDataSourcesImpl implements ProjectLocalDataSources {
  final ProjectStore store;
  ProjectLocalDataSourcesImpl(this.store);
  @override
  Future<Unit> addProjectDraft(ProjectModel project)async {
    await store.saveDraft(project);
    return unit;
  }

  @override
  Future<Unit> cacheProject(ProjectModel project)async {
    await store.saveProjectById(project.id,project);
    return unit;
  }

  @override
  Future<Unit> cacheProjects(List<ProjectModel> projects)async {
    await store.saveProjects(projects);
    return unit;
  }

  @override
  Future<List<ProjectModel>> getAllProjects(PrivacyType privacyType)async {
    final projects = await store.getProjects(privacyType);
    return projects.map((e) => ProjectModel.fromEntity(e)).toList();
  }

  @override
  Future<ProjectModel?> getProjectById(String id)async {
    final project = await store.getProjectById(id);
    if (project != null) {
      return ProjectModel.fromEntity(project);
    }
    return null;
  }

  @override
  Future<ProjectModel?> getDraft()async {
    final project = await store.getDraft();
    if (project != null) {
      return ProjectModel.fromEntity(project);
    }
    return null;
  }

  @override
  Future<Unit> Cleardraft()async {
    await store.clearDraft();
    return unit;
  }

}