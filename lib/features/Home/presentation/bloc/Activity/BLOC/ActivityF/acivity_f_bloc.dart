import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/features/Home/domain/entities/Activity.dart';
import 'package:jci_app/features/Home/domain/usercases/MeetingsUseCase.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/Participants/particpants_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/widgets/Functions.dart';
import 'package:jci_app/features/auth/domain/entities/Member.dart';

import '../../../../../../../core/config/services/verification.dart';
import   '../../../../../../../core/error/Failure.dart';
import '../../../../../../../core/strings/failures.dart';
import '../../../../../../../core/usescases/usecase.dart';
import '../../../../../domain/entities/Event.dart';
import '../../../../../domain/entities/Meeting.dart';
import '../../../../../domain/entities/training.dart';
import '../../../../../domain/usercases/EventUseCases.dart';
import '../../../../../domain/usercases/TrainingUseCase.dart';
import '../formzBloc/formz_bloc.dart';
part 'acivity_f_event.dart';




part 'acivity_f_state.dart';

class AcivityFBloc extends Bloc<AcivityFEvent, AcivityFState> {
  final GetALlEventsUseCase getALlEventsUseCase;
final GetALlMeetingsUseCase getALlMeetingsUseCase;
final GetEventByIdUseCase getEventByIdUseCase;
final GetMeetingByIdUseCase getMeetingByIdUseCase;
final GetTrainingByIdUseCase getTrainingByIdUseCase;
  final GetEventsOfTheMonthUseCase getEventsOfTheMonthUseCase;
  final GetTrainingsOfTheMonthUseCase getTrainingsOfTheMonthUseCase;
  final GetALlTrainingsUseCase getALlTrainingsUseCase;
  final ParticpantsBloc participantBloc;

  AcivityFBloc({required  this.getTrainingsOfTheMonthUseCase,
    required  this.getALlTrainingsUseCase,
    required  this.participantBloc,

    required  this.getTrainingByIdUseCase,
    required  this.getMeetingByIdUseCase,
    required  this.getEventsOfTheMonthUseCase,
    required  this.getALlEventsUseCase,
    required  this.getALlMeetingsUseCase,
    required  this.getEventByIdUseCase,




  }) : super(AcivityFInitial()) {
    on<AcivityFEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetActivitiesOfMonthEvent>(_getActivityOfMonth);
on<RefreshActivities>(refresh);
on<GetActivitiesByid>(_getActivityByid);
on<GetAllActivitiesEvent>(_getAllActivities);
on<SearchTextChanged>(SearchCat);
  }
  void refresh(
      RefreshActivities event ,
      Emitter<AcivityFState> emit
      ) {



      add(GetActivitiesOfMonthEvent(act: event.act));
    add(GetAllActivitiesEvent(act: event.act));


  }

  void _getActivityByid(
      GetActivitiesByid event,
      Emitter<AcivityFState> emit

      )async {
    emit(ActivityLoadingState());
     if (event.act==activity.Events){
    final failureOrEvents= await getEventByIdUseCase(event.id);
    emit(_mapFailureActivityId(failureOrEvents));}
    else if (event.act==activity.Trainings){
      final failureOrEvents= await getTrainingByIdUseCase(event.id);
      emit(_mapFailureActivityId(failureOrEvents));
    }
    else if (event.act==activity.Meetings){
      final failureOrEvents= await getMeetingByIdUseCase(event.id);
      emit(_mapFailureActivityId(failureOrEvents));
    }
  }

  void _getAllActivities(
      GetAllActivitiesEvent event,
      Emitter<AcivityFState> emit

      )async {
    emit(ActivityLoadingState());
    if (event.act==activity.Events){
      final failureOrEvents= await getALlEventsUseCase(NoParams());

      emit(_mapFailureOrActivityToState(failureOrEvents));
    }
    else if (event.act==activity.Trainings){
      final failureOrEvents= await getALlTrainingsUseCase(NoParams());
      emit(_mapFailureOrActivityToState(failureOrEvents));
    }
    else if (event.act==activity.Meetings){
      final failureOrEvents= await getALlMeetingsUseCase(NoParams());
      emit(_mapFailureOrActivityToState(failureOrEvents));
    }
  }


void _getActivityOfMonth(
      GetActivitiesOfMonthEvent event,
      Emitter<AcivityFState> emit

      )async {

    if (event.act==activity.Events){
      emit(ActivityLoadingState());
      final failureOrEvents= await getEventsOfTheMonthUseCase(NoParams());
      emit(_mapFailureOrActivityMonthToState(failureOrEvents));


    }
    else if (event.act==activity.Trainings){
      emit(ActivityLoadingState());

      final failureOrEvents= await getTrainingsOfTheMonthUseCase(NoParams());
      emit(_mapFailureOrActivityMonthToState(failureOrEvents));

    }
    else if (event.act==activity.Meetings){
      emit(ActivityLoadingState());

      final failureOrEvents= await getALlMeetingsUseCase(NoParams());
      emit(_mapFailureOrActivityMonthToState(failureOrEvents));
    }
}









AcivityFState _mapFailureOrActivityToState(Either<Failure, List<Activity>> either) {
    return either.fold(
          (failure) => ErrorActivityState(message: mapFailureToMessage(failure)),
          (act) {

            participantBloc.add(initstateList(act: mapObjects(act))); log("eee"+participantBloc.state.toString());
            return ActivityLoadedState(
       activitys: act,
      );}
    );
  }

  AcivityFState _mapFailureOrActivityMonthToState(Either<Failure, List<Activity>> either) {
    return either.fold(
          (failure) => ErrorActivityState(message: mapFailureToMessage(failure)),
          (act) => ActivityLoadedMonthState(
       activitys: act,
      ),
    );
  }AcivityFState _mapFailureActivityId(Either<Failure, Activity>either) {
    return either.fold(
          (failure) => ErrorActivityState(message: mapFailureToMessage(failure)),
          (act) => ACtivityByIdLoadedState(
       activity: act,
      ),
    );
  }
void SearchCat(SearchTextChanged event,Emitter<AcivityFState>emit ) async {


    emit(SearchLoading());

        final categories = _filterCategories(event.searchText);
       emit( SearchLoaded(categories));
     if (categories.isEmpty)
        emit(SearchError("not found"));


  }

  List<Category> _filterCategories(String searchText) {

    return Category.values.where((category) => category.name.contains(searchText)).toList();
  }
}
