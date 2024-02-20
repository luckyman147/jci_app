part of 'events_bloc.dart';


abstract class EventsEvent  extends Equatable   {
  const EventsEvent();
  @override
  List<Object> get props => [];
}
class GetEventsEvent extends EventsEvent {
  const GetEventsEvent();
}
class GetEventsOfweek extends EventsEvent {


}
class GetEventsOfmonth extends EventsEvent {

}
class RefreshEvents extends EventsEvent {

}
