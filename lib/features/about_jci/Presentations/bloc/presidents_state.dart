part of 'presidents_bloc.dart';
enum presidentsStates{Initial,Loading,Loaded,Error,Changed,ErrorCrete}
 class PresidentsState extends Equatable {
  final presidentsStates state;
  final List<President> presidents;
  final bool hasReachedMax;
  final String message;
  const PresidentsState({this.state=presidentsStates.Initial,this.presidents=const [],this.message='',this.hasReachedMax=false});
  PresidentsState copyWith({presidentsStates? state,List<President>? presidents,String? message,bool? hasReachedMax}) {
    return PresidentsState(state: state??this.state,presidents: presidents??this.presidents,message: message??this.message,hasReachedMax: hasReachedMax??this.hasReachedMax);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [state,presidents,message,hasReachedMax];
}

class PresidentsInitial extends PresidentsState {
  @override
  List<Object> get props => [];
}
