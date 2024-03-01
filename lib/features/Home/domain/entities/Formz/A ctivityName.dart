import 'package:formz/formz.dart';


enum ActivityNameValidationError { empty }

class ActivityName extends FormzInput<String, ActivityNameValidationError> {

  const ActivityName.pure() : super.pure('');
  const ActivityName.dirty( [super.value = '']) : super.dirty();

  @override
  ActivityNameValidationError? validator(String value) {
    if (value.isEmpty) return ActivityNameValidationError.empty;

    return null;
  }
}


