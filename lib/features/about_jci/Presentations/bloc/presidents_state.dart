part of 'presidents_bloc.dart';
enum presidentsStates{Initial,Loading,Loaded,Error,Changed}
 class PresidentsState extends Equatable {
  final presidentsStates state;
  final List<President> presidents;
  final String message;
  const PresidentsState({this.state=presidentsStates.Initial,this.presidents=const [],this.message=''});
  PresidentsState copyWith({presidentsStates? state,List<President>? presidents,String? message}) {
    return PresidentsState(state: state??this.state,presidents: presidents??this.presidents,message: message??this.message);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [state,presidents];
}

class PresidentsInitial extends PresidentsState {
  @override
  List<Object> get props => [];
}
