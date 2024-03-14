part of 'get_teams_bloc.dart';

abstract class GetTeamsState extends Equatable {
  const GetTeamsState();
}

class GetTeamsInitial extends GetTeamsState {
  @override
  List<Object> get props => [];
}
class GetTeamsLoading extends GetTeamsState {
  @override
  List<Object> get props => [];
}
class GetTeamsLoaded extends GetTeamsState {
  final List<Team> teams;
  GetTeamsLoaded(this.teams);
  @override
  List<Object> get props => [teams];
}
class GetTeamsError extends GetTeamsState {
  final String message;
  GetTeamsError(this.message);
  @override
  List<Object> get props => [message];
}
class GetTeamsLoadedByid extends GetTeamsState{
  final Team team;
  GetTeamsLoadedByid(this.team);
  @override
  List<Object> get props => [team];}
