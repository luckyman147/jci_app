import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

enum BeginTimeOfDayValidationError { empty }

class BeginTimeOfDayInput extends FormzInput<TimeOfDay?, BeginTimeOfDayValidationError> {
  const BeginTimeOfDayInput.pure() : super.pure(null);
  const BeginTimeOfDayInput.dirty([TimeOfDay? value]) : super.dirty(value);

  static TimeOfDay _getDefaultDateTimeOfDay() {
    return TimeOfDay.now();
  }

  @override
  BeginTimeOfDayValidationError? validator(TimeOfDay? value) {
    if (value == null) return BeginTimeOfDayValidationError.empty;
    return null;
  }
}
enum RegistrationTimeOfDayValidationError { empty }

class RegistrationTimeOfDayInput extends FormzInput<TimeOfDay?, RegistrationTimeOfDayValidationError> {
  const RegistrationTimeOfDayInput.pure() : super.pure(null);
  const RegistrationTimeOfDayInput.dirty([TimeOfDay? value]) : super.dirty(value);

  static TimeOfDay _getDefaultTimeOfDay() {
    return TimeOfDay.now();
  }

  @override
  RegistrationTimeOfDayValidationError? validator(TimeOfDay? value) {
    if (value == null) return RegistrationTimeOfDayValidationError.empty;
    return null;
  }
}
enum EndTimeOfDayValidationError { empty }

class EndTimeOfDayInput extends FormzInput<TimeOfDay?, EndTimeOfDayValidationError> {
  const EndTimeOfDayInput.pure() : super.pure(null);
  const EndTimeOfDayInput.dirty([TimeOfDay? value]) : super.dirty(value);

  static TimeOfDay _getDefaultTimeOfDay() {
    return TimeOfDay.now();
  }

  @override
  EndTimeOfDayValidationError? validator(TimeOfDay? value) {
    if (value == null) return EndTimeOfDayValidationError.empty;
    return null;
  }
}
