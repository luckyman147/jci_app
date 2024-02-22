import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../../../core/error/Failure.dart';
import '../../../../../../core/strings/failures.dart';
import '../../../../../../core/usescases/usecase.dart';
import '../../../../domain/entities/Event.dart';
import '../../../../domain/usercases/EventUseCases.dart';
import '../events_bloc.dart';

part 'evebnts_of_thewwekend_event.dart';
part 'evebnts_of_thewwekend_state.dart';

class EvebntsOfThewwekendBloc extends Bloc<EvebntsOfThewwekendEvent, EvebntsOfThewwekendState> {
  final GetEventsOfTheWeekUseCase getEventsOfTheWeekUseCase;
  EvebntsOfThewwekendBloc({ required this.getEventsOfTheWeekUseCase}) : super(EvebntsOfThewwekendInitial()) {
   on<GetEventsOfweek>(_getEventsOfTheWeek);
  }
  void _getEventsOfTheWeek(
      GetEventsOfweek event,
      Emitter<EvebntsOfThewwekendState> emit

      )async {
    emit(EventsOfWeekLoadingState());
    final failureOrEvents= await getEventsOfTheWeekUseCase(NoParams());
    emit(_mapFailureOrEventsOfweekToState(failureOrEvents));

  }
  EvebntsOfThewwekendState _mapFailureOrEventsOfweekToState(Either<Failure, List<EventOfTheWeek>> either) {
    return either.fold(
          (failure) => EventsErrorOfTheweekenState(message: mapFailureToMessage(failure)),
          (events) => EventsOfWeekLoadedState(
        eventsOfWeek: events,
      ),
    );
  }
}
