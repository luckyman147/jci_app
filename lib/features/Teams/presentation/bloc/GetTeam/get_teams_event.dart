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
}