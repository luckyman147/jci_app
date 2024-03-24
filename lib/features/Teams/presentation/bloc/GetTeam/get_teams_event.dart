part of 'get_teams_bloc.dart';

abstract class GetTeamsEvent extends Equatable {
  const GetTeamsEvent();
}
class GetTeams extends GetTeamsEvent {





  @override
  List<Object> get props => [];
}
class GetTeamById extends GetTeamsEvent {
  final String id;
  GetTeamById(this.id);
  @override
  List<Object> get props => [id];
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