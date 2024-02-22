import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/core/usescases/usecase.dart';


import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../domain/entities/Event.dart';
import '../../../domain/usercases/EventUseCases.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final GetALlEventsUseCase getALlEventsUseCase;

  final GetEventsOfTheMonthUseCase getEventsOfTheMonthUseCase;
  EventsBloc({ required this.getALlEventsUseCase,  required this.getEventsOfTheMonthUseCase}) : super(EventsInitial()) {
    on<GetEventsEvent>(_getAllEVents);

    on<GetEventsOfmonth>(_getEventsOfTheMonth);
    on<RefreshEvents>(_refreshEvents);
  }

  void _getEventsOfTheMonth(
      GetEventsOfmonth event,
      Emitter<EventsState> emit

      )async {
    emit(EventsLoadingState());
    final failureOrEvents= await getEventsOfTheMonthUseCase(NoParams());
    emit(_mapFailureOrEventsOfmONTHToState(failureOrEvents));

  }





  void _refreshEvents(RefreshEvents event, Emitter<EventsState> emit) {
emit(EventsOfMonthLoadingState());


    add(GetEventsOfmonth());

  }
  void _getAllEVents (
      GetEventsEvent event,
      Emitter<EventsState> emit

      )async {
    emit(EventsLoadingState());
    final failureOrEvents= await getALlEventsUseCase(NoParams());
emit(_mapFailureOrEventsToState(failureOrEvents));

  }


  EventsState _mapFailureOrEventsToState(Either<Failure, List<Event>> either) {
    return either.fold(
          (failure) => EventsErrorState(message: mapFailureToMessage(failure)),
          (events) => EventsLoadedState(
        events: events,
      ),
    );
  }

  EventsState _mapFailureOrEventsOfmONTHToState(Either<Failure, List<EventOfTheMonth>> either) {
    return either.fold(
          (failure) => EventsErrorState(message: mapFailureToMessage(failure)),
          (events) => EventsOfMonthLoadedState(
        eventsOfMonth: events,
      ),
    );
  }

}
