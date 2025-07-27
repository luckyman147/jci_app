part of 'get_teams_bloc.dart';

abstract class GetTeamsEvent extends Equatable {
  const GetTeamsEvent();
}
class GetTeams extends GetTeamsEvent {

  final bool isRefreshed;

final bool isPrivate;
final DocumentSnapshot? lastDocument;
  const GetTeams(this.lastDocument, this.isRefreshed, {required this.isPrivate});


  @override
  List<Object> get props => [isPrivate,isRefreshed];
}
class GetMoreTeams extends GetTeamsEvent {


final bool isPrivate;
final DocumentSnapshot? lastDocument;
  const GetMoreTeams(this.lastDocument, {required this.isPrivate});


  @override
  List<Object> get props => [isPrivate];
}
class GetTeamById extends GetTeamsEvent {
  final Map<String,dynamic> fields;
  const GetTeamById(this.fields);
  @override
  List<Object> get props => [fields];
}class AddTeam extends GetTeamsEvent {
  final Team team;
  const AddTeam(this.team);
  @override
  List<Object> get props => [team];
}
class DeleteTeam extends GetTeamsEvent {
  final String id;
  const DeleteTeam(this.id);
  @override
  List<Object> get props => [id];
}
class UpdateTeam extends GetTeamsEvent {
  final Team team;
  const UpdateTeam(this.team);
  @override
  List<Object> get props => [team];
}
class GetTeamByName extends GetTeamsEvent {
  final Map<String,dynamic> fields;
  const GetTeamByName(this.fields);
  @override
  List<Object> get props => [fields];
}
class initStatus extends GetTeamsEvent {



  @override
  List<Object> get props => [];
}
class nitMembersEvent extends GetTeamsEvent {

  final List<Map<String,dynamic>> members;
  const nitMembersEvent(this.members);
  @override
  List<Object> get props => [members];
}
class AddMembers extends GetTeamsEvent {
  final List<Map<String,dynamic>> members;
  const AddMembers(this.members);
  @override
  List<Object> get props => [members];
}
class DeleteMembers extends GetTeamsEvent {
  final List<Map<String,dynamic>> members;
  const DeleteMembers(this.members);
  @override
  List<Object> get props => [members];
}
class  checkIfPartipated extends GetTeamsEvent {

  const checkIfPartipated();
  @override
  List<Object> get props => [];
}
class UpdateTeamMember extends GetTeamsEvent{
  final TeamInput fields;

  const UpdateTeamMember({required this.fields});

  @override
  // TODO: implement props
  List<Object?> get props => [fields];
}
class InviteMembers extends GetTeamsEvent{
final TeamInput teamfi;
  const InviteMembers({required this.teamfi});

  @override
  // TODO: implement props
  List<Object?> get props => [teamfi];
}
class JoinTeam extends GetTeamsEvent{
  final String Teamid ;

  const JoinTeam({required this.Teamid});

  @override
  // TODO: implement props
  List<Object?> get props => [Teamid];

}


