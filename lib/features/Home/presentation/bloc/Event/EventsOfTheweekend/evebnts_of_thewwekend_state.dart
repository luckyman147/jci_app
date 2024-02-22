part of 'evebnts_of_thewwekend_bloc.dart';


abstract class EvebntsOfThewwekendState extends Equatable {
  @override
  List<Object> get props => [];
}

class EvebntsOfThewwekendInitial extends EvebntsOfThewwekendState {}
class EventsOfWeekLoadingState extends EvebntsOfThewwekendState {}
class EventsOfWeekLoadedState extends EvebntsOfThewwekendState  {
  final List<EventOfTheWeek> eventsOfWeek;
  EventsOfWeekLoadedState({required this.eventsOfWeek});
  @override
  List<Object> get props => [eventsOfWeek];
}
class EventsErrorOfTheweekenState extends EvebntsOfThewwekendState {
  final String message;
  EventsErrorOfTheweekenState({required this.message});
  @override
  List<Object> get props => [message];
}