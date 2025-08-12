part of 'get_teams_bloc.dart';
enum TeamStatus { initial, success, error ,LoadingJoin,Deleted,DeletedError,IsRefresh,Loading,Created,Updated,LoadedTeams ,LoadedTeam}
 class GetTeamsState extends Equatable {
   final TeamStatus status;
   final List<Team> teams;
   final List<Team> homeTeams;
   final bool hasReachedMax;
   final String errorMessage;
   final List<dynamic> isExisted;
   final List<dynamic> members;
   final Team? teamById;

   final DocumentSnapshot? lastDocument;
  const GetTeamsState({this.status = TeamStatus.initial,
   this.hasReachedMax = false,
    this.lastDocument,
   this.teams = const [],
    this.homeTeams=const [],
    this.isExisted = const[],
    this.teamById ,

    this.members = const [],
   this.errorMessage = ""}
      );

   GetTeamsState copyWith({

     DocumentSnapshot? lastDocument,
     List<dynamic >?isExisted,
     List<dynamic>? members,
     TeamStatus? status,
     List<Team>? teams,
     List<Team>? homeTeams,
     bool? hasReachedMax,
     String? errorMessage,
     Team? teamById
   }) {
     return GetTeamsState(
       homeTeams: homeTeams ?? this.homeTeams,
       lastDocument: lastDocument??this.lastDocument,
        isExisted: isExisted ?? this.isExisted,
        members: members ?? this.members,
       status: status ?? this.status,
       teams: teams ?? this.teams,
       teamById: teamById ?? this.teamById,
       hasReachedMax: hasReachedMax ?? this.hasReachedMax,
       errorMessage: errorMessage ?? this.errorMessage,
     );
   }

   @override
   List<Object?> get props => [status,homeTeams,teamById, teams,members,isExisted, hasReachedMax, errorMessage];
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

  @override
  final List<Team> teams;
  const GetTeamsLoaded(this.teams);
  @override
  List<Object> get props => [teams,];
}
class GetTeamsError extends GetTeamsState {
  final String message;
  const GetTeamsError(this.message);
  @override
  List<Object> get props => [message];
}
class GetTeamsLoadedByid extends GetTeamsState{
  final Team team;
  const GetTeamsLoadedByid(this.team);
  @override
  List<Object> get props => [team];}
