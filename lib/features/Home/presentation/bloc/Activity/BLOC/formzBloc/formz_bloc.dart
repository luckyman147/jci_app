import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../domain/entities/Formz/A ctivityName.dart';
import '../../../../../domain/entities/Formz/Date.dart';
import '../../../../../domain/entities/Formz/Description.dart';
import '../../../../../domain/entities/Formz/Director.dart';
import '../../../../../domain/entities/Formz/Image.dart';
import '../../../../../domain/entities/Formz/Location.dart';

part 'formz_event.dart';
part 'formz_state.dart';

class FormzBloc extends Bloc<FormzEvent, FormzState> {
  FormzBloc() : super(FormzInitial()) {
    on<FormzEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<ActivityNameChanged>(_onActivityNameChanged);
    on<LocationChanged>(_onLocationChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<ImageInputChanged>(_onImageInputChanged);
    on<LeaderNameChanged>(_onLeaderNameChanged);
    on<ProfesseurNameChanged>(_onProfesseurNameChanged);
    on<BeginTimeChanged>(_onBeginDateChanged);
    on<EndTimeChanged>(_onEndDateChanged);
    on<RegistraTimeChanged>(_onRegistrationDateChanged);
    on<CategoryChanged>(_onCategoryChanged);
    on<jokerChanged>(_JokerChanged);

    on<jokerTimeChanged>(_JokerTimeChanged);
  }
  void _onActivityNameChanged(
      ActivityNameChanged event, Emitter<FormzState> emit) {
    final activityName = ActivityName.dirty(event.activityName);
    emit(
      state.copyWith(
          activityName: activityName,
          isValid: Formz.validate([state.activityName, activityName])),
    );
  }

  void _onLocationChanged(
      LocationChanged event, Emitter<FormzState> emit) {
    final location = Location.dirty(event.location);
    emit(
      state.copyWith(
          location: location,
          isValid: Formz.validate([state.location, location])),
    );
  }

  void _onDescriptionChanged(
      DescriptionChanged event, Emitter<FormzState> emit) {
    final description = Description.dirty(event.description);
    emit(
      state.copyWith(
          description: description,
          isValid: Formz.validate([state.description, description])),
    );
  }

  void _onBeginDateChanged(
      BeginTimeChanged event, Emitter<FormzState> emit) {
    final date = BeginTimeInput.dirty(event.date);
    emit(
      state.copyWith(
          beginTimeInput: date,
          isValid: Formz.validate([date, state.beginTimeInput])),
    );
  }

  void _onEndDateChanged(
      EndTimeChanged event, Emitter<FormzState> emit) {
    final date = EndTimeInput.dirty(event.date);
    emit(
      state.copyWith(
          endTimeInput: date,
          isValid: Formz.validate([date, state.endTimeInput])),
    );
    debugPrint(state.endTimeInput.value.toString());
  }

  void _JokerChanged(
      jokerChanged event, Emitter<FormzState> emit) {
    final date = JokerTimeInput.dirty(event.joke);
    emit(
      state.copyWith(
          jokerTimeInput: date,
          isValid: Formz.validate([date, state.joker])),
    );
  } void _JokerTimeChanged(
      jokerTimeChanged event, Emitter<FormzState> emit) {
    final date = JokerDateofDayInput.dirty(event.joketimer);
    emit(
      state.copyWith(
          jokerDateofDayInput: date,
          isValid: Formz.validate([date, state.joker])),
    );
  }

  void _onRegistrationDateChanged(
      RegistraTimeChanged event, Emitter<FormzState> emit) {
    final date = RegistrationTimeInput.dirty(event.date);
    emit(
      state.copyWith(
          registrationTimeInput: date,
          isValid: Formz.validate([date, state.registrationTimeInput])),
    );
  }

  void _onImageInputChanged(
      ImageInputChanged event, Emitter<FormzState> emit) {
    final imageInput = ImageInput.dirty(event.imageInput);
    emit(
      state.copyWith(
          imageInput: imageInput,
          isValid: Formz.validate([state.imageInput, imageInput])),
    );
  }

  void _onLeaderNameChanged(
      LeaderNameChanged event, Emitter<FormzState> emit) {
    final leaderName = LeaderName.dirty(event.leaderName);
    emit(
      state.copyWith(
          leaderName: leaderName,
          isValid: Formz.validate([state.leaderName, leaderName])),
    );
  } void _onProfesseurNameChanged(
      ProfesseurNameChanged event, Emitter<FormzState> emit) {
    final professeurName = LeaderName.dirty(event.profName);
    emit(
      state.copyWith(
          leaderName: professeurName,
          isValid: Formz.validate([state.professeurName, professeurName])),
    );
  }

  void _onCategoryChanged(
      CategoryChanged event, Emitter<FormzState> emit) {
    emit(state.copyWith(
      category: event.category,
    ));
  }
}
