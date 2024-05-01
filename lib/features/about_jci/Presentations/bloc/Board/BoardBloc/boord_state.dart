part of 'boord_bloc.dart';
enum BoardStatus {Initial,Loading,Loaded,Error,Changed,Removed}
 class BoordState extends Equatable {
   final List<BoardYear> boardYears;
   final String message;
    final BoardStatus state;
   final List<int> Listlength;


   const BoordState({this.state=BoardStatus.Initial,this.boardYears=const [],this.message='',this.Listlength=const []});
  BoordState copyWith({BoardStatus? state,List<BoardYear>? boardYears,String? message,List<int>? Listlength}) {
    return BoordState(state: state??this.state,boardYears: boardYears??this.boardYears,message: message??this.message,Listlength: Listlength??this.Listlength);
  }


  @override
  // TODO: implement props
  List<Object?> get props => [state,boardYears,message,Listlength];
}

class BoordInitial extends BoordState {
  @override
  List<Object> get props => [];
}
