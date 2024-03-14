part of 'team_actions_bloc.dart';

abstract class TeamActionsEvent extends Equatable {
  const TeamActionsEvent();
}
class AddTeam extends TeamActionsEvent {
  final Team team;
  AddTeam(this.team);
  @override
  List<Object> get props => [team];
}