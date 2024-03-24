part of 'timeline_bloc.dart';

 class TimelineState extends Equatable {
   final Map<String,dynamic> timeline;


   const TimelineState({this.timeline=const {}});
   TimelineState copyWith({
     Map<String,dynamic>? timeline,
     List<Map<String, dynamic>>? tasks,
     String? errorMessage,
   }) {
     return TimelineState(


       timeline: timeline??this.timeline,

     );
   }
  @override
  // TODO: implement props
  List<Object?> get props => [timeline];
}

class TimelineInitial extends TimelineState {
  @override
  List<Object> get props => [];
}
