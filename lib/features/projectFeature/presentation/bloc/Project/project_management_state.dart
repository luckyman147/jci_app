part of 'project_management_bloc.dart';
enum ProjectStateStatus { initial, loading, LoadedProjects,LoadedProject, failure,success }
  enum DraftStatus { initial, loading, Saved, failure,success }
 class ProjectManagementState extends Equatable {

  final Project? project;
  final Project? DraftProject;
  final List<Project> projects;
  final List<Project> ProjectSearch;
  final ProjectStateStatus status;
  final DraftStatus draftStatus ;
  final ProjectCreationStatus? projectCreationStatus;
  final String? ErrorMessage;
  final String finalMessage;


   ProjectManagementState({


     this.projectCreationStatus,
    this.DraftProject,
    this.project,
    this.draftStatus = DraftStatus.initial,
    this.projects = const [],
    this.ProjectSearch = const [],
    this.status = ProjectStateStatus.initial,
    this.ErrorMessage,
    this.finalMessage = '',

  });
  ProjectManagementState copyWith({
    Project? project,
    Project? DraftProject,
    List<Project>? projects,
    List<Project>? ProjectSearch,
    DraftStatus? draftStatus,
    ProjectCreationStatus? projectCreationStatus,
    ProjectStateStatus? status,
    String? ErrorMessage,
    String? finalMessage,
  }) {
    return ProjectManagementState(
      draftStatus: draftStatus ?? this.draftStatus,
      projectCreationStatus: projectCreationStatus ?? this.projectCreationStatus,
      DraftProject: DraftProject ?? this.DraftProject,
      project: project ?? this.project,
      projects: projects ?? this.projects,
      ProjectSearch: ProjectSearch ?? this.ProjectSearch,
      status: status ?? this.status,

      ErrorMessage: ErrorMessage ?? this.ErrorMessage,
      finalMessage: finalMessage ?? this.finalMessage,
    );
  }
  @override
  // TODO: implement props
  List<Object?> get props => [
    DraftProject,
    projectCreationStatus,
    project,
    projects,
    draftStatus,
    ProjectSearch,
    status,
    ErrorMessage,
    finalMessage,
  ];
}

final class ProjectManagementInitial extends ProjectManagementState {
  @override
  List<Object> get props => [];
}
