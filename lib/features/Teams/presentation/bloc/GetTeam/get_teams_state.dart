part of 'get_teams_bloc.dart';
enum TeamStatus { initial, success, error ,Deleted,DeletedError,IsRefresh}
 class GetTeamsState extends Equatable {
   final TeamStatus status;
   final List<Team> teams;
   final bool hasReachedMax;
   final String errorMessage;
   final List<dynamic> isExisted;
   final List<dynamic> members;


  const GetTeamsState({this.status = TeamStatus.initial,
   this.hasReachedMax = false,
   this.teams = const [],
    this.isExisted = const[],

    this.members = const [],
   this.errorMessage = ""}
      );

   GetTeamsState copyWith({

     List<dynamic >?isExisted,
     List<dynamic>? members,
     TeamStatus? status,
     List<Team>? teams,
     bool? hasReachedMax,
     String? errorMessage,
   }) {
     return GetTeamsState(
        isExisted: isExisted ?? this.isExisted,
        members: members ?? this.members,
       status: status ?? this.status,
       teams: teams ?? this.teams,
       hasReachedMax: hasReachedMax ?? this.hasReachedMax,
       errorMessage: errorMessage ?? this.errorMessage,
     );
   }

   @override
   List<Object?> get props => [status, teams,members,isExisted, hasReachedMax, errorMessage];
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
  List<Object> get props => [teams,];
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
