import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';

import '../../../../../../../core/config/services/verification.dart';
import '../../../../../../../core/error/Failure.dart';
import '../../../../../../../core/strings/failures.dart';
import '../../../../../domain/entities/Activity.dart';
import '../../../../../domain/usercases/EventUseCases.dart';
import '../../../../../domain/usercases/MeetingsUseCase.dart';
import '../../../../../domain/usercases/TrainingUseCase.dart';

part 'particpants_event.dart';
part 'particpants_state.dart';

class ParticpantsBloc extends Bloc<ParticpantsEvent, ParticpantsState> {
final   ParticipateEventUseCase participateEventUseCase;
final LeaveEventUseCase leaveEventUseCase;
final ParticipateTrainingUseCase participateTrainingUseCase;
final LeaveTrainingUseCase leaveTrainingUseCase;
final ParticipateMeetingUseCase participateUseCase;
final LeaveMeetingUseCase leaveMeetingUseCase;

  ParticpantsBloc(this.participateEventUseCase, this.leaveEventUseCase, this.participateTrainingUseCase, this.leaveTrainingUseCase, this.participateUseCase, this.leaveMeetingUseCase)
      : super(ParticpantsInitial( isParticipantAdded: [])) {
    on<ParticpantsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<AddParticipantEvent>(_AddParticipent);


    on<RemoveParticipantEvent>(_RemoveParticipent);
    on<initstateList>(init);

  }
void _AddParticipent(
      AddParticipantEvent event,
      Emitter<ParticpantsState> emit
      ) async {
if(event.act ==activity.Events){

    final result = await participateEventUseCase(event.id);
    emit(_eitherDoneMessageOrErrorState(result, 'Participated Successfully',event.index));
}

else if(event.act ==activity.Trainings){
  final result = await participateTrainingUseCase(event.id);
  emit(_eitherDoneMessageOrErrorState(result, 'Participated Successfully',event.index));
}
else if(event.act ==activity.Meetings) {
  final result = await participateUseCase(event.id);
  emit(_eitherDoneMessageOrErrorState(
      result, 'Participated Successfully', event.index));
}
}void _RemoveParticipent(
    RemoveParticipantEvent event,
      Emitter<ParticpantsState> emit
      ) async {

if (event.act == activity.Events) {
  final result = await leaveEventUseCase(event.id);
  emit(_eitherDoneMessageOrErrorState(
      result, 'Removed Participant Successfully', event.index));
} else if (event.act == activity.Trainings) {
  final result = await leaveTrainingUseCase(event.id);
  emit(_eitherDoneMessageOrErrorState(
      result, 'Removed Participant Successfully', event.index));
} else if (event.act == activity.Meetings) {
  final result = await leaveMeetingUseCase(event.id);
  emit(_eitherDoneMessageOrErrorState(
      result, 'Removed Participant Successfully', event.index));


}}
void init(initstateList event, Emitter<ParticpantsState> emit) {



   emit(  state.copyWith(isParticipantAdded: event.act));
   emit(ParticipantChanged(isParticipantAdded: event.act, pp: event.act));
    debugPrint(event.act.toString());
    debugPrint(state.isParticipantAdded.toString());

}

  ParticpantsState _eitherDoneMessageOrErrorState(
    Either<Failure, Unit> either, String message,int index) {
  return either.fold(
        (failure) => ParticipantFailedState(

      message: mapFailureToMessage(failure), isParticipantAdded: state.isParticipantAdded ?? []
    ),
        (_) {
          List<Map<String,dynamic>>? act = state.isParticipantAdded;
          act![index]['isPart'] =  !state.isParticipantAdded![index]['isPart'];
      emit (    state.copyWith(isParticipantAdded: act ));
          emit(ParticipantChanged(isParticipantAdded: act, pp: act));

          debugPrint(state.isParticipantAdded.toString());
        return  ParticipantSuccessState(
              message: message, isParticipantAdded: act);

        }
  );

}}