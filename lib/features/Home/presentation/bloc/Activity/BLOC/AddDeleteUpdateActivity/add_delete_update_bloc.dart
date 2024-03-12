import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:jci_app/features/Home/domain/entities/Activity.dart';

import 'package:jci_app/features/Home/domain/entities/training.dart';
import 'package:jci_app/features/Home/domain/usercases/MeetingsUseCase.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/widgets/Functions.dart';

import '../../../../../../../core/error/Failure.dart';
import '../../../../../../../core/strings/failures.dart';
import '../../../../../domain/entities/Event.dart';


import '../../../../../domain/entities/Meeting.dart';
import '../../../../../domain/usercases/EventUseCases.dart';
import '../../../../../domain/usercases/TrainingUseCase.dart';

part 'add_delete_update_event.dart';
part 'add_delete_update_state.dart';

class AddDeleteUpdateBloc
    extends Bloc<AddDeleteUpdateEvent, AddDeleteUpdateState> {
  final CreateEventUseCase createEventUseCase;
  final CreateTrainingUseCase creatTrainingUseCase;
  final CreateMeetingUseCase createMeetingUseCase;  final DeleteEventUseCase deleteEventUseCase;
  final UpdateMeetingUseCase updateMeetingUseCase;
  final UpdateTrainingUseCase updateTrainingUseCase;
  final UpdateEventUseCase updateEventUseCase;
  final DeleteMeetingUseCase deleteMeetingUseCase;
  final DeleteTrainingUseCase deleteTrainingUseCase;


  AddDeleteUpdateBloc({required this.createEventUseCase,
    required this.deleteEventUseCase,
    required this.updateEventUseCase,
    required this.updateMeetingUseCase,
    required this.deleteMeetingUseCase,
    required this.updateTrainingUseCase,
    required this.deleteTrainingUseCase,

    required this.createMeetingUseCase,

    required this.creatTrainingUseCase})
      : super(AddDeleteUpdateInitial(

  )) {
    on<AddDeleteUpdateEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<DeleteActivityEvent>(_deleteActivity);
    on<UpdateActivityEvent>(_UpdateActivity);
    on<AddACtivityEvent>(_addActivity);

  }

  void _addActivity(
      AddACtivityEvent event, Emitter<AddDeleteUpdateState> emit) async {
    emit(LoadingAddDeleteUpdateState());
    if (!validateTime(event.act.ActivityBeginDate, event.act.ActivityEndDate)){
      emit(ErrorAddDeleteUpdateState(message: 'End Time must be greater than Start '));

    }  else {
      log(event.act.toString());
      if (event.type == activity.Events) {
        final result = await createEventUseCase((event.act) as Event);
        emit(_eitherDoneMessageOrErrorState(result, 'Event Added'));
      } else if (event.type == activity.Trainings) {
        debugPrint("coverimagzefro ");
        debugPrint(event.act.CoverImages.first);
        final result = await creatTrainingUseCase((event.act) as Training);
        emit(_eitherDoneMessageOrErrorState(result, 'Training Added'));
      }
      else if (event.type == activity.Meetings) {
        final result = await createMeetingUseCase((event.act) as Meeting);
        emit(_eitherDoneMessageOrErrorState(result, 'Meeting Added'));
      }
    }
  }
  void _deleteActivity(
      DeleteActivityEvent event,
      Emitter<AddDeleteUpdateState> emit

      )async {

    if (event.act==activity.Events){
      final failureOrEvents= await deleteEventUseCase(event.id);
      emit(_deletedActivityOrFailure(failureOrEvents));
    }
    else if (event.act==activity.Trainings){
      final failureOrEvents= await deleteTrainingUseCase(event.id);
      emit(_deletedActivityOrFailure(failureOrEvents));
    }
    else if (event.act==activity.Meetings){
      final failureOrEvents= await deleteMeetingUseCase(event.id);
      emit(_deletedActivityOrFailure(failureOrEvents));

    }

  }




  void _UpdateActivity(
      UpdateActivityEvent event,
      Emitter<AddDeleteUpdateState> emit

      )async {
    if (event.act==activity.Events){
      if (!validateTime(event.active.ActivityBeginDate, event.active.ActivityEndDate)){
        emit(ErrorAddDeleteUpdateState(message: 'End Time must be greater than Start Time'));

      }
      else{
      final failureOrEvents= await updateEventUseCase((event.active) as Event);
      emit(_UpdatedActivityOrFailure(failureOrEvents));}
    }
    else if (event.act==activity.Trainings){
      if (!validateTime(event.active.ActivityBeginDate, event.active.ActivityEndDate)){
        emit(ErrorAddDeleteUpdateState(message: 'End Time must be greater than Start Time'));

      }
      else{
      final failureOrEvents= await updateTrainingUseCase((event.active) as Training);
      emit(_UpdatedActivityOrFailure(failureOrEvents));}

    }
    else if (event.act==activity.Meetings){
      if (!validateTime(event.active.ActivityBeginDate, event.active.ActivityEndDate)){
        emit(ErrorAddDeleteUpdateState(message: 'End Time must be greater than Start Time'));

      }
      else{
      final failureOrEvents= await updateMeetingUseCase((event.active) as Meeting);
      emit(_UpdatedActivityOrFailure(failureOrEvents));}
    }

  }


  AddDeleteUpdateState _eitherDoneMessageOrErrorState(
      Either<Failure, Unit> either, String message) {
    return either.fold(
      (failure) => ErrorAddDeleteUpdateState(
        message: mapFailureToMessage(failure),
      ),
      (_) => MessageAddDeleteUpdateState(message: message),
    );
  }
  AddDeleteUpdateState _deletedActivityOrFailure(Either<Failure, Unit> either) {
    return either.fold(
          (failure) => ErrorAddDeleteUpdateState(message: mapFailureToMessage(failure)),
          (act) => DeletedActivityMessage(message: 'Deleted With Success'),
    );
  } AddDeleteUpdateState _UpdatedActivityOrFailure(Either<Failure, Unit> either) {
    return either.fold(
          (failure) => ErrorAddDeleteUpdateState(message: mapFailureToMessage(failure)),
          (act) => ActivityUpdatedState(message: 'Updated With Success'),
    );
  }



}
