import 'package:formz/formz.dart';

import '../Event.dart';

enum EventFormzValidationError { empty }

class EventFormz extends FormzInput<Event?, EventFormzValidationError> {
  const EventFormz.pure() : super.pure(null);
  const EventFormz.dirty(Event? value) : super.dirty(value);

  @override
  EventFormzValidationError? validator(Event? value) {
    if (value == null) return EventFormzValidationError.empty;

    return null;
  }
}