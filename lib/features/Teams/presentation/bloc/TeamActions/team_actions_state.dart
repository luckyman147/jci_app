part of 'team_actions_bloc.dart';

abstract class TeamActionsState extends Equatable {

  const TeamActionsState();
}

class TeamActionsInitial extends TeamActionsState {
  @override
  List<Object> get props => [];
}
class ErrorMessage extends TeamActionsState {
  final String message;
  ErrorMessage({required this.message});
  @override
  List<Object> get props => [message];
}
class TeamAdded extends TeamActionsState {
  final String message;
  TeamAdded({required this.message});
  @override
  List<Object> get props => [message];
}

