import '../../data/models/ProjectModel.dart';

enum ProjectCreationStep {
  creatingTeams,
  teamsCreated,
  creatingProject,
  projectCreated,
  updatingTeamsWithProjectId,
  teamsUpdated,
  completed,
  failed,
}

class ProjectCreationStatus {
  final ProjectCreationStep step;
  final String? message;
  final double? progress;
  final ProjectModel? project;

  ProjectCreationStatus({
    required this.step,
    this.message,
    this.progress,
    this.project,
  });
}
