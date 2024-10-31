part of 'timeline_bloc.dart';

abstract class TimelineEvent extends Equatable {
  const TimelineEvent();
}
class initTimeline extends TimelineEvent {
  final Map<String,dynamic> timelines;
  const initTimeline( this.timelines);
  @override
  List<Object> get props => [timelines];
}
class onStartDateChanged extends TimelineEvent{
  final DateTime startdate;

  const onStartDateChanged({required this.startdate});

  @override
  // TODO: implement props
  List<Object?> get props => [startdate];
}
class onEndDateDateChanged extends TimelineEvent{
  final DateTime enddate;

  const onEndDateDateChanged({required this.enddate});

  @override
  // TODO: implement props
  List<Object?> get props => [enddate];
}

