part of 'events_bloc.dart';


abstract class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object> get props => [];
}

class EventsInitial extends EventsState {}

class EventsLoadingState extends EventsState {}
class EventsOfMonthLoadingState extends EventsState {}

class EventsLoadedState extends EventsState {
  final List<Event> events;
  EventsLoadedState({required this.events});
  @override
  List<Object> get props => [events];
}class EventsOfMonthLoadedState extends EventsState {
  final List<EventOfTheMonth> eventsOfMonth;
  EventsOfMonthLoadedState({required this.eventsOfMonth});
  @override
  List<Object> get props => [eventsOfMonth];
}
class EventsErrorState extends EventsState {
  final String message;
  EventsErrorState({required this.message});
  @override
  List<Object> get props => [message];
}