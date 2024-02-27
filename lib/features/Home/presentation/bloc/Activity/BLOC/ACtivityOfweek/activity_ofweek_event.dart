part of 'activity_ofweek_bloc.dart';


abstract class ActivityOfweekEvent extends Equatable{
  const ActivityOfweekEvent();
}
class RefreshActivitiesWeek extends ActivityOfweekEvent {
  final activity act;

  const RefreshActivitiesWeek({required this.act});
  @override
  List<Object> get props => [];
}
class GetOfWeekActivitiesEvent extends ActivityOfweekEvent {
  final activity act;

  const GetOfWeekActivitiesEvent({required this.act});

  @override
  List<Object> get props => [];
}