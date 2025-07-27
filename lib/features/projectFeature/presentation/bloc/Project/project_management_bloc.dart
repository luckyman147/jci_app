import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:googleapis/shared.dart';
import 'package:jci_app/features/common/enums/PrivacyType.dart';
import 'package:jci_app/features/projectFeature/presentation/enum/ProjectCreationStep.dart';

import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../../../core/usescases/usecase.dart';
import '../../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../../../domain/entities/Project.dart';
import '../../../domain/usescases/ProjectUseCases.dart';

part 'project_management_event.dart';
part 'project_management_state.dart';
class ProjectManagementBloc extends Bloc<ProjectManagementEvent, ProjectManagementState> {
  final CreateProjectUseCase createProjectUseCase;
  final UpdateProjectUseCase updateProjectUseCase;
  final DeleteProjectUseCase deleteProjectUseCase;
  final GetAllProjectsUseCase getAllProjectsUseCase;
  final GetProjectByIdUseCase getProjectByIdUseCase;
  final SaveDraftProjectUseCase saveDraftProjectUseCase;
  final ClearProjectUseCase clearProjectUseCase;
  final GetDraftProjectUseCase getDraftProjectUseCase;
  final deleteTeamFromProjectUseCase deleteTeamUseCase;

  ProjectManagementBloc({
    required this.createProjectUseCase,
    required this.updateProjectUseCase,
    required this.deleteProjectUseCase,
    required this.getAllProjectsUseCase,
    required this.getProjectByIdUseCase,
    required this.saveDraftProjectUseCase,
    required this.clearProjectUseCase,
    required this.getDraftProjectUseCase,
    required this.deleteTeamUseCase,
  }) : super(ProjectManagementInitial()) {
    on<CreateProjectevent>(_onCreateProject);
    on<UpdateProjectEvent>(_onUpdateProject);
    on<DeleteProjectEvent>(_onDeleteProject);
    on<GetAllProjectsEvent>(_onGetAllProjects);
    on<GetProjectByIdEvent>(_onGetProjectById);
    on<SaveDraftProjectEvent>(_onSaveDraftProject);
    on<clearDraftEvent>(_onClearDraft);
    on<GetDraftProjectEvent>(_onGetDraft);
    on<DeleteTeamFromProjectEvent>(_onDeleteTeamFromProject);
  }

  Future<void> _onCreateProject(CreateProjectevent event, Emitter<ProjectManagementState> emit) async {
    emit(state.copyWith(status: ProjectStateStatus.loading));
    await emit.forEach(
      createProjectUseCase.call(event.project),
      onData: (result) => result.fold(
            (failure) => state.copyWith(
          status: ProjectStateStatus.failure,
          ErrorMessage: mapFailureToMessage(failure),
        ),
            (status) => state.copyWith(
          status: ProjectStateStatus.success,
          projectCreationStatus: status,
        ),
      ),
    );
  }

  Future<void> _onUpdateProject(UpdateProjectEvent event, Emitter<ProjectManagementState> emit) async {
    emit(state.copyWith(status: ProjectStateStatus.loading));
    final result = await updateProjectUseCase(event.project);
    emit(_handleEitherResult(
      result: result,
      onSuccess: (_) => state.copyWith(status: ProjectStateStatus.success),
    ));
  }

  Future<void> _onDeleteProject(DeleteProjectEvent event, Emitter<ProjectManagementState> emit) async {
    emit(state.copyWith(status: ProjectStateStatus.loading));
    final result = await deleteProjectUseCase(event.projectId);
    emit(_handleEitherResult(
      result: result,
      onSuccess: (_) => state.copyWith(status: ProjectStateStatus.success),
    ));
  }

  Future<void> _onGetAllProjects(GetAllProjectsEvent event, Emitter<ProjectManagementState> emit) async {
    emit(state.copyWith(status: ProjectStateStatus.loading));
    final result = await getAllProjectsUseCase(event.privacyType);
    emit(_handleEitherResult(
      result: result,
      onSuccess: (projects) => state.copyWith(
        status: ProjectStateStatus.LoadedProjects,
        projects: projects,
        ProjectSearch: projects
      ),
    ));
  }

  Future<void> _onGetProjectById(GetProjectByIdEvent event, Emitter<ProjectManagementState> emit) async {
    emit(state.copyWith(status: ProjectStateStatus.loading));
    final result = await getProjectByIdUseCase(event.projectId);
    emit(_handleEitherResult(
      result: result,
      onSuccess: (project) => state.copyWith(
        status: ProjectStateStatus.LoadedProject,
        project: project,
      ),
    ));
  }

  Future<void> _onSaveDraftProject(SaveDraftProjectEvent event, Emitter<ProjectManagementState> emit) async {
    final result = await saveDraftProjectUseCase(event.project);
    emit(_handleEitherResult(
      result: result,
      onSuccess: (_) => state.copyWith(draftStatus: DraftStatus.Saved),
    ));
  }

  Future<void> _onClearDraft(clearDraftEvent event, Emitter<ProjectManagementState> emit) async {
    final result = await clearProjectUseCase(NoParams());
    emit(_handleEitherResult(
      result: result,
      onSuccess: (_) => state.copyWith(
        draftStatus: DraftStatus.success,
        DraftProject: null,
      ),
    ));
  }

  Future<void> _onGetDraft(GetDraftProjectEvent event, Emitter<ProjectManagementState> emit) async {
    emit(state.copyWith(draftStatus: DraftStatus.loading));
    final result = await getDraftProjectUseCase(NoParams());
    emit(_handleEitherResult(
      result: result,
      onSuccess: (project) => state.copyWith(
        status: ProjectStateStatus.LoadedProject,
        DraftProject: project,
      ),
    ));
  }

  Future<void> _onDeleteTeamFromProject(DeleteTeamFromProjectEvent event, Emitter<ProjectManagementState> emit) async {
    final result = await deleteTeamUseCase(event.paramIds);
    emit(_handleEitherResult(
      result: result,
      onSuccess: (_) => state.copyWith(status: ProjectStateStatus.success),
    ));
  }

  ProjectManagementState _handleEitherResult<T>({
    required Either<Failure, T> result,
    required Function(T) onSuccess,
  }) {
    return result.fold(
          (failure) => state.copyWith(
        status: ProjectStateStatus.failure,
        ErrorMessage: mapFailureToMessage(failure),
      ),
          (data) => onSuccess(data),
    );
  }
}

