import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

enum BeginTimeValidationError { empty }

class BeginTimeInput extends FormzInput<DateTime?, BeginTimeValidationError> {
  const BeginTimeInput.pure() : super.pure(null);
  const BeginTimeInput.dirty([DateTime? value]) : super.dirty(value);

  static DateTime _getDefaultDateTime() {
    return DateTime.now();
  }

  @override
  BeginTimeValidationError? validator(DateTime? value) {
    if (value == null) return BeginTimeValidationError.empty;
    return null;
  }
}
enum RegistrationTimeValidationError { empty }

class RegistrationTimeInput extends FormzInput<DateTime?, RegistrationTimeValidationError> {
  const RegistrationTimeInput.pure() : super.pure(null);
  const RegistrationTimeInput.dirty([DateTime? value]) : super.dirty(value);

  static DateTime _getDefaultDateTime() {
    return DateTime.now();
  }

  @override
  RegistrationTimeValidationError? validator(DateTime? value) {
    if (value == null) return RegistrationTimeValidationError.empty;
    return null;
  }
}
enum EndTimeValidationError { empty }

class EndTimeInput extends FormzInput<DateTime?, EndTimeValidationError> {
  const EndTimeInput.pure() : super.pure(null);
  const EndTimeInput.dirty([DateTime? value]) : super.dirty(value);

  static DateTime _getDefaultDateTime() {
    return DateTime.now();
  }

  @override
  EndTimeValidationError? validator(DateTime? value) {
    if (value == null) return EndTimeValidationError.empty;
    return null;
  }
}
enum JokerTimeValidationError { empty }

class JokerTimeInput extends FormzInput<DateTime?, JokerTimeValidationError> {
  const JokerTimeInput.pure() : super.pure(null);
  const JokerTimeInput.dirty([DateTime? value]) : super.dirty(value);

  static DateTime _getDefaultDateTime() {
    return DateTime.now();
  }

  @override
  JokerTimeValidationError? validator(DateTime? value) {
    if (value == null) return JokerTimeValidationError.empty;
    return null;
  }
}
enum JokerDateofDayValidationError { empty }

class JokerDateofDayInput extends FormzInput<TimeOfDay?, JokerDateofDayValidationError> {
  const JokerDateofDayInput.pure() : super.pure(null);
  const JokerDateofDayInput.dirty([TimeOfDay? value]) : super.dirty(value);

  static DateTime _getDefaultDateTime() {
    return DateTime.now();
  }

  @override
  JokerDateofDayValidationError? validator(TimeOfDay? value) {
    if (value == null) return JokerDateofDayValidationError.empty;
    return null;
  }
}
