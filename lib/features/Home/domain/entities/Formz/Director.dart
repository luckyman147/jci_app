import 'package:formz/formz.dart';


enum LeaderNameValidationError { empty }

class LeaderName extends FormzInput<String, LeaderNameValidationError> {

  const LeaderName.pure() : super.pure('');
  const LeaderName.dirty( [super.value = '']) : super.dirty();

  @override
  LeaderNameValidationError? validator(String value) {
    if (value.isEmpty) return LeaderNameValidationError.empty;

    return null;
  }
}
enum ProfesseurNameValidationError { empty }

class ProfesseurName extends FormzInput<String, ProfesseurNameValidationError> {

  const ProfesseurName.pure() : super.pure('');
  const ProfesseurName.dirty( [super.value = '']) : super.dirty();

  @override
  ProfesseurNameValidationError? validator(String value) {
    if (value.isEmpty) return ProfesseurNameValidationError.empty;

    return null;
  }
}


