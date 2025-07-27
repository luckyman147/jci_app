part of 'project_management_bloc.dart';

sealed class ProjectManagementEvent extends Equatable {
  const ProjectManagementEvent();
}
final class CreateProjectevent extends ProjectManagementEvent{
  final Project project;
  const CreateProjectevent({required this.project});
  @override
  List<Object> get props => [project];
}
final class UpdateProjectEvent extends ProjectManagementEvent{
  final Project project;
  const UpdateProjectEvent({required this.project});
  @override
  List<Object> get props => [project];
}
final class DeleteProjectEvent extends ProjectManagementEvent{
  final String projectId;
  const DeleteProjectEvent({required this.projectId});
  @override
  List<Object> get props => [projectId];
}
final class GetAllProjectsEvent extends ProjectManagementEvent{

  final PrivacyType privacyType;
  const GetAllProjectsEvent(this.privacyType);
  @override
  List<Object> get props => [privacyType];
}
final class GetProjectByIdEvent extends ProjectManagementEvent{
  final String projectId;
  const GetProjectByIdEvent({required this.projectId});
  @override
  List<Object> get props => [projectId];
}
final class GetProjectsByNameEvent extends ProjectManagementEvent{
  final String name;
  const GetProjectsByNameEvent({required this.name});
  @override
  List<Object> get props => [name];
}
final class clearDraftEvent extends ProjectManagementEvent{
  const clearDraftEvent();
  @override
  List<Object> get props => [];
}
final class GetDraftProjectEvent extends ProjectManagementEvent{

  const GetDraftProjectEvent();
  @override
  List<Object> get props => [];
}
final class SaveDraftProjectEvent extends ProjectManagementEvent{
  final Project project;
  const SaveDraftProjectEvent({required this.project});
  @override
  List<Object> get props => [project];
}
final class DeleteTeamFromProjectEvent extends ProjectManagementEvent {
  final ParamIds paramIds;
  const DeleteTeamFromProjectEvent({required this.paramIds});
  @override
  List<Object> get props => [paramIds];


}
