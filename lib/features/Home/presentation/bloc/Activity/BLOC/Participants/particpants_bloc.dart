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
import '../../../../../domain/usercases/ActivityUseCases.dart';
import '../../../../../domain/usercases/EventUseCases.dart';
import '../../../../../domain/usercases/MeetingsUseCase.dart';
import '../../../../../domain/usercases/TrainingUseCase.dart';

part 'particpants_event.dart';
part 'particpants_state.dart';

class ParticpantsBloc extends Bloc<ParticpantsEvent, ParticpantsState> {
  final ParticipateActivityUseCases participateActivityUseCases;
  final LeaveActivityUseCases leaveActivityUseCases;


  ParticpantsBloc({required this.leaveActivityUseCases, required this.participateActivityUseCases})
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


    final result = await participateActivityUseCases(event.act);
    emit(_eitherDoneMessageOrErrorState(result, 'Participated Successfully',event.index,emit));

}void _RemoveParticipent(
    RemoveParticipantEvent event,
      Emitter<ParticpantsState> emit
      ) async {

  final result = await leaveActivityUseCases(event.act);
  emit(_eitherDoneMessageOrErrorState(
      result, 'Removed Participant Successfully', event.index,emit));
}
void init(initstateList event, Emitter<ParticpantsState> emit) {



   emit(  state.copyWith(isParticipantAdded: event.act));
   emit(ParticipantChanged(isParticipantAdded: event.act, pp: event.act));
    debugPrint(event.act.toString());
    debugPrint(state.isParticipantAdded.toString());

}

  ParticpantsState _eitherDoneMessageOrErrorState(
    Either<Failure, Unit> either, String message,int index,Emitter<ParticpantsState> emit) {
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