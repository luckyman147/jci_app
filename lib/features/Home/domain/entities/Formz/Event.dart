import 'package:formz/formz.dart';

import '../Activity/event/Event.dart';
import '../Activitys/ActivityBasics.dart';

enum EventFormzValidationError { empty }

class EventFormz extends FormzInput<ActivityBasics?, EventFormzValidationError> {
  const EventFormz.pure() : super.pure(null);
  const EventFormz.dirty(ActivityBasics? value) : super.dirty(value);

  @override
  EventFormzValidationError? validator(ActivityBasics? value) {
    if (value == null) return EventFormzValidationError.empty;

    return null;
  }
}