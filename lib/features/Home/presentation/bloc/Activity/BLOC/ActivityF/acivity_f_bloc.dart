import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/core/config/services/store.dart';
import 'package:jci_app/features/Home/data/model/TrainingModel/TrainingModel.dart';
import 'package:jci_app/features/Home/data/model/events/EventModel.dart';
import 'package:jci_app/features/Home/data/model/meetingModel/MeetingModel.dart';
import 'package:jci_app/features/Home/domain/Dtos/ActivityParam.dart';
import 'package:jci_app/features/Home/domain/entities/Activity.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/Participants/particpants_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/widgets/Functions/Functions.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';

import '../../../../../../../core/error/Failure.dart';
import '../../../../../../../core/strings/failures.dart';
import '../../../../../../../core/usescases/usecase.dart';
import '../../../../../domain/entities/Category.dart';
import '../../../../../domain/enums/ActivityEnum.dart';
import '../../../../../domain/usercases/ActivityUseCases.dart';

import '../formzBloc/formz_bloc.dart';
part 'acivity_f_event.dart';

part 'acivity_f_state.dart';

class AcivityFBloc extends Bloc<AcivityFEvent, AcivityFState> {
  final GetActivityByIdUseCases getActivityByIdUseCases;
  final GetAllActivitiesUseCases getEventsOfTheMonthUseCase;
  final GetActivityByNameUseCases getActivityByNameUseCases;
  final ParticpantsBloc participantBloc;
  final Store store;
  final GetAllActivitiesUseCases getAllActivitiesUseCases;
  final ParticipateActivityUseCases participateActivityUseCases;
  final LeaveActivityUseCases leaveActivityUseCases;
  AcivityFBloc(
      this.participateActivityUseCases, this.leaveActivityUseCases, this.store,
      {required this.getActivityByNameUseCases,
      required this.getEventsOfTheMonthUseCase,
      required this.participantBloc,
      required this.getActivityByIdUseCases,
      required this.getAllActivitiesUseCases})
      : super(const AcivityFInitial()) {
    on<AcivityFEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetActivitiesOfMonthEvent>(_getActivityOfMonth);
    on<RefreshActivities>(refresh);
    on<GetActivitiesByid>(_getActivityByid);
    on<GetAllActivitiesEvent>(_getAllActivities);
    on<AddParticipantEvent>(_AddParticipent);
    on<RemoveParticipantEvent>(_RemoveParticipent);
    on<GetActivitiesByName>(_getActivityByName);
  }
  void refresh(RefreshActivities event, Emitter<AcivityFState> emit) {
    add(GetActivitiesOfMonthEvent(act: event.act));
    add(GetAllActivitiesEvent(act: event.act));
  }

  void _getActivityByid(
      GetActivitiesByid event, Emitter<AcivityFState> emit) async {
    emit(state.copyWith(activityfetchState: ActivityFetchState.Loading));

    final failureOrEvents = await getActivityByIdUseCases(event.params);

    emit(_mapSuccessFailureActivity(failureOrEvents, (act) {
      return state.copyWith(
          activityById: act,
          activityfetchState: ActivityFetchState.ActivityByIdLoaded);
    }));
  }

  void _getAllActivities(
      GetAllActivitiesEvent event, Emitter<AcivityFState> emit) async {
    emit(state.copyWith(activityfetchState: ActivityFetchState.Loading));

    final failureOrEvents = await getAllActivitiesUseCases(event.act);

    emit(_mapSuccessFailureActivity(failureOrEvents, (act) {
      return state.copyWith(
          activities: act,
          activityfetchState: ActivityFetchState.ActivityLoaded,
          activitiesSearch: act);
    }));
  }

  void _getActivityByName(
      GetActivitiesByName event, Emitter<AcivityFState> emit) async {
    emit(state.copyWith(activityfetchState: ActivityFetchState.Loading));

    final failureOrEvents = await getActivityByNameUseCases(event.params);
    emit(_mapSuccessFailureActivity(
        failureOrEvents,
        (act) => state.copyWith(
            activitiesSearch: act,
            activityfetchState: ActivityFetchState.ActivityLoaded)));
  }

  void _getActivityOfMonth(
      GetActivitiesOfMonthEvent event, Emitter<AcivityFState> emit) async {
    emit(state.copyWith(activityfetchState: ActivityFetchState.Loading));

    final failureOrEvents = await getEventsOfTheMonthUseCase(event.act);
    emit(_mapSuccessFailureActivity(
        failureOrEvents,
        (act) => state.copyWith(
            activities: act,
            activityfetchState: ActivityFetchState.ACtivityLoadedMonth,
            activitiesSearch: act)));
  }

  void _AddParticipent(
      AddParticipantEvent event, Emitter<AcivityFState> emit) async {
    // TODO: search events by id
    emit(state.copyWith(
        activityfetchState: ActivityFetchState.LoadingButton,
        eventid: event.act.Eventid));
    final result = await participateActivityUseCases(event.act);
    final user = await store.getUserId();
    emit(_mapSuccessFailureActivity(result, (act) {
      final activitys = state.activities
          .firstWhere((element) => element.id == event.act.Eventid);
      final index = state.activities
          .indexWhere((element) => element.id == event.act.Eventid);
      final activitiesPartcipants = activitys.Participants;
      activitiesPartcipants.add(user ?? "");
      return CopyActivity(event.act.type, activitys, activitiesPartcipants,
          index, ActivityFetchState.Participate);
    }));
  }

  AcivityFState CopyActivity(
      activity type,
      Activity activitys,
      List<String> activitiesPartcipants,
      int index,
      ActivityFetchState status) {
    if (type == activity.Trainings) {
      return TRainingPartcipantFun(
          activitys, activitiesPartcipants, index, status);
    }
    if (type == activity.Meetings) {
      return MeetingPOartFun(activitys, activitiesPartcipants, index, status);
    } else {
      return EventPartFun(activitys, activitiesPartcipants, index, status);
    }
  }

  AcivityFState EventPartFun(
      Activity activitys,
      List<String> activitiesPartcipants,
      int index,
      ActivityFetchState status) {
    EventModel eventModel = (activitys as EventModel).fromActivity(activitys);
    EventModel event = eventModel.copywith(activitiesPartcipants);
    state.activities[index] = event;
    final cState = status;
    return state.copyWith(
        eventid: "",
        activities: state.activities,
        activityfetchState: cState,
        activitiesSearch: state.activities);
  }

  AcivityFState MeetingPOartFun(
      Activity activitys,
      List<String> activitiesPartcipants,
      int index,
      ActivityFetchState status) {
    MeetingModel meeting = (activitys as MeetingModel).fromActivity(activitys);
    MeetingModel newMeeting = meeting.copywith(activitiesPartcipants);
    state.activities[index] = newMeeting;
    final cState = status;

    return state.copyWith(
        activities: state.activities,
        activityfetchState: cState,
        activitiesSearch: state.activities,
        eventid: "");
  }

  AcivityFState TRainingPartcipantFun(
      Activity activitys,
      List<String> activitiesPartcipants,
      int index,
      ActivityFetchState status) {
    TrainingModel training =
        (activitys as TrainingModel).fromActivity(activitys);

    TrainingModel newTraining = training.copywith(activitiesPartcipants);
    state.activities[index] = newTraining;
    final cState = status;
    return state.copyWith(
        activities: state.activities,
        activityfetchState: cState,
        activitiesSearch: state.activities,
        eventid: "");
  }

  void _RemoveParticipent(
      RemoveParticipantEvent event, Emitter<AcivityFState> emit) async {
    emit(state.copyWith(
        activityfetchState: ActivityFetchState.LoadingButton,
        eventid: event.act.Eventid));

    final result = await leaveActivityUseCases(event.act);
    final user = await store.getUserId();
    emit(_mapSuccessFailureActivity(result, (act) {
      final activitys = state.activities
          .firstWhere((element) => element.id == event.act.Eventid);
      final index = state.activities
          .indexWhere((element) => element.id == event.act.Eventid);
      final activitiesPartcipants = activitys.Participants;
      activitiesPartcipants.remove(user);

      return CopyActivity(event.act.type, activitys, activitiesPartcipants,
          index, ActivityFetchState.Left);
    }));
  }

  AcivityFState _mapSuccessFailureActivity<T>(
      Either<Failure, T> either, Function(T) onSuccess) {
    return either.fold(
        (failure) => state.copyWith(
            errorMessage: mapFailureToMessage(failure),
            activityfetchState: ActivityFetchState.Error),
        (act) => onSuccess(act));
  }
}
