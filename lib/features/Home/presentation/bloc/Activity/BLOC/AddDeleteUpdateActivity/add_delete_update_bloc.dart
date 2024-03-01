import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jci_app/features/Home/domain/entities/Activity.dart';
import 'package:jci_app/features/Home/domain/entities/Formz/A%20ctivityName.dart';
import 'package:jci_app/features/Home/domain/entities/Formz/Date.dart';

import 'package:jci_app/features/Home/domain/entities/Formz/Description.dart';
import 'package:jci_app/features/Home/domain/entities/Formz/Location.dart';
import 'package:jci_app/features/Home/domain/entities/Formz/TimeOfDay.dart';
import 'package:jci_app/features/Home/domain/entities/training.dart';
import 'package:jci_app/features/Home/domain/usercases/MeetingsUseCase.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';

import '../../../../../../../core/error/Failure.dart';
import '../../../../../../../core/strings/failures.dart';
import '../../../../../domain/entities/Event.dart';
import '../../../../../domain/entities/Formz/Director.dart';
import '../../../../../domain/entities/Formz/Image.dart';
import '../../../../../domain/entities/Meeting.dart';
import '../../../../../domain/usercases/EventUseCases.dart';
import '../../../../../domain/usercases/TrainingUseCase.dart';

part 'add_delete_update_event.dart';
part 'add_delete_update_state.dart';

class AddDeleteUpdateBloc
    extends Bloc<AddDeleteUpdateEvent, AddDeleteUpdateState> {
  final CreateEventUseCase createEventUseCase;
  final CreateTrainingUseCase creatTrainingUseCase;
  final CreateMeetingUseCase createMeetingUseCase;
  AddDeleteUpdateBloc({required this.createEventUseCase,
    required this.createMeetingUseCase,

    required this.creatTrainingUseCase})
      : super(AddDeleteUpdateInitial(

  )) {
    on<AddDeleteUpdateEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<AddACtivityEvent>(_addActivity);

  }

  void _addActivity(
      AddACtivityEvent event, Emitter<AddDeleteUpdateState> emit) async {
    emit(LoadingAddDeleteUpdateState());
    if (event.type == activity.Events) {
      debugPrint("coverimagze ecvent");
      debugPrint(event.act.CoverImages.first);
      final result = await createEventUseCase((event.act) as Event);
      emit(_eitherDoneMessageOrErrorState(result, 'Event Added'));
    }  else if (event.type == activity.Trainings) {
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

  AddDeleteUpdateState _eitherDoneMessageOrErrorState(
      Either<Failure, Unit> either, String message) {
    return either.fold(
      (failure) => ErrorAddDeleteUpdateState(
        message: mapFailureToMessage(failure),
      ),
      (_) => MessageAddDeleteUpdateState(message: message),
    );
  }


}
