import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/core/usescases/usecase.dart';
import 'package:meta/meta.dart';

import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../domain/entities/Event.dart';
import '../../../domain/usercases/EventUseCases.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final GetALlEventsUseCase getALlEventsUseCase;
  final GetEventsOfTheWeekUseCase getEventsOfTheWeekUseCase;
  final GetEventsOfTheMonthUseCase getEventsOfTheMonthUseCase;
  EventsBloc({ required this.getALlEventsUseCase, required this.getEventsOfTheWeekUseCase, required this.getEventsOfTheMonthUseCase}) : super(EventsInitial()) {
    on<GetEventsEvent>(_getAllEVents);
    on<GetEventsOfweek>(_getEventsOfTheWeek);
    on<GetEventsOfmonth>(_getEventsOfTheMonth);
    on<RefreshEvents>(_refreshEvents);
  }

  void _getEventsOfTheMonth(
      GetEventsOfmonth event,
      Emitter<EventsState> emit

      )async {
    emit(EventsLoadingState());
    final failureOrEvents= await getEventsOfTheMonthUseCase(NoParams());
    emit(_mapFailureOrPostsToState(failureOrEvents));
  }
  void _getEventsOfTheWeek(
      GetEventsOfweek event,
      Emitter<EventsState> emit

      )async {
    emit(EventsLoadingState());
    final failureOrEvents= await getEventsOfTheWeekUseCase(NoParams());
    emit(_mapFailureOrPostsToState(failureOrEvents));
  }
  void _refreshEvents(RefreshEvents event, Emitter<EventsState> emit) {
    emit(EventsLoadingState());
    add(GetEventsEvent());
    add(GetEventsOfmonth());
    add(GetEventsOfweek());
  }
  void _getAllEVents (
      GetEventsEvent event,
      Emitter<EventsState> emit

      )async {
    emit(EventsLoadingState());
    final failureOrEvents= await getALlEventsUseCase(NoParams());
emit(_mapFailureOrPostsToState(failureOrEvents));

  }


  EventsState _mapFailureOrPostsToState(Either<Failure, List<Event>> either) {
    return either.fold(
          (failure) => EventsErrorState(message: mapFailureToMessage(failure)),
          (events) => EventsLoadedState(
        events: events,
      ),
    );
  }

}
