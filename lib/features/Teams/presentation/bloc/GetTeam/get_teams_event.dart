part of 'get_teams_bloc.dart';

abstract class GetTeamsEvent extends Equatable {
  const GetTeamsEvent();
}
class GetTeams extends GetTeamsEvent {


final bool isPrivate;
final bool isUpdated;
  GetTeams({required this.isPrivate,this.isUpdated=true});


  @override
  List<Object> get props => [];
}
class GetTeamById extends GetTeamsEvent {
  final Map<String,dynamic> fields;
  GetTeamById(this.fields);
  @override
  List<Object> get props => [fields];
}class AddTeam extends GetTeamsEvent {
  final Team team;
  AddTeam(this.team);
  @override
  List<Object> get props => [team];
}
class DeleteTeam extends GetTeamsEvent {
  final String id;
  DeleteTeam(this.id);
  @override
  List<Object> get props => [id];
}
class UpdateTeam extends GetTeamsEvent {
  final Team team;
  UpdateTeam(this.team);
  @override
  List<Object> get props => [team];
}
class GetTeamByName extends GetTeamsEvent {
  final Map<String,dynamic> fields;
  GetTeamByName(this.fields);
  @override
  List<Object> get props => [fields];
}
class initStatus extends GetTeamsEvent {



  @override
  List<Object> get props => [];
}
class nitMembersEvent extends GetTeamsEvent {

  final List<Map<String,dynamic>> members;
  nitMembersEvent(this.members);
  @override
  List<Object> get props => [members];
}
class AddMembers extends GetTeamsEvent {
  final List<Map<String,dynamic>> members;
  AddMembers(this.members);
  @override
  List<Object> get props => [members];
}
class DeleteMembers extends GetTeamsEvent {
  final List<Map<String,dynamic>> members;
  DeleteMembers(this.members);
  @override
  List<Object> get props => [members];
}
class  checkIfPartipated extends GetTeamsEvent {

  checkIfPartipated();
  @override
  List<Object> get props => [];
}
class UpdateTeamMember extends GetTeamsEvent{
  final TeamInput fields;

  UpdateTeamMember({required this.fields});

  @override
  // TODO: implement props
  List<Object?> get props => [fields];
}
class InviteMembers extends GetTeamsEvent{
final TeamInput teamfi;
  InviteMembers({required this.teamfi});

  @override
  // TODO: implement props
  List<Object?> get props => [teamfi];
}



