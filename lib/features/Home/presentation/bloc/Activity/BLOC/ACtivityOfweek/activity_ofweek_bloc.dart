

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/features/Home/domain/entities/Activity.dart';
import 'package:meta/meta.dart';

import '../../../../../../../core/error/Failure.dart';
import '../../../../../../../core/strings/failures.dart';
import '../../../../../../../core/usescases/usecase.dart';
import '../../../../../domain/usercases/EventUseCases.dart';
import '../../../../../domain/usercases/MeetingsUseCase.dart';
import '../../../../../domain/usercases/TrainingUseCase.dart';
import '../../activity_cubit.dart';

part 'activity_ofweek_event.dart';
part 'activity_ofweek_state.dart';

class ActivityOfweekBloc extends Bloc<ActivityOfweekEvent, ActivityOfweekState> {
  final GetEventsOfTheWeekUseCase getEventsOfTheWeekUseCase;
  final GetMeetingsOfTheWeekUseCase getMeetingsOfTheWeek;
  final GetTrainingsOfTheWeekUseCase getTrainingsOfTheWeek;
  ActivityOfweekBloc({ required this.getEventsOfTheWeekUseCase, required this.getMeetingsOfTheWeek,required  this.getTrainingsOfTheWeek}) : super(ActivityOfweekInitial()) {
    on<GetOfWeekActivitiesEvent>(_getActivitieOfWeek);
    on<RefreshActivitiesWeek>(_refresh);
  }
  void _refresh(
      RefreshActivitiesWeek event ,
      Emitter<ActivityOfweekState> emit
      ) {
    emit(ActivityOfTheWeekLoadingState());

    add(GetOfWeekActivitiesEvent(act: event.act));




  }

  void _getActivitieOfWeek(
      GetOfWeekActivitiesEvent event,
      Emitter<ActivityOfweekState> emit

      )async {
    emit(ActivityOfTheWeekLoadingState());
    if  (event.act == activity.Events) {
      final failureOrEvents = await getEventsOfTheWeekUseCase(NoParams());
      emit(_mapFailureOrActivityWeekToState(failureOrEvents));

    }
    else if (event.act == activity.Meetings){
      final failureOrMeetings = await getMeetingsOfTheWeek(NoParams());
      emit(_mapFailureOrActivityWeekToState(failureOrMeetings));
    }
    else if (event.act == activity.Trainings){
      final failureOrTrainings = await getTrainingsOfTheWeek(NoParams());
      emit(_mapFailureOrActivityWeekToState(failureOrTrainings));
    }

  }
  ActivityOfweekState _mapFailureOrActivityWeekToState(Either<Failure, List<Activity>> either) {
    return either.fold(
          (failure) =>ACtivityWeekError(message: mapFailureToMessage(failure)),
          (act) => ActivityWeekLoaded(
       act: act,
      ),
    );
  }

}
