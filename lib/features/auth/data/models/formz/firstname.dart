import 'package:formz/formz.dart';

enum FirstnameValidationError { empty, tooShort, tooLong }

class Firstname extends FormzInput<String, FirstnameValidationError> {
  const Firstname.pure() : super.pure('');
  const Firstname.dirty([super.value = '']) : super.dirty();
  static const _minLength = 6;
  static const _maxLength = 20;
  @override
  FirstnameValidationError? validator(String value) {
    if (value.isEmpty) return FirstnameValidationError.empty;

    return null;
  }
}
extension on FirstnameValidationError {
  String text() {
    switch (this) {
      case FirstnameValidationError.tooShort:
        return 'Firstname must be at least 6 characters';
      case FirstnameValidationError.empty:
        return 'Please enter a firstname';
      case FirstnameValidationError.tooLong:
        return 'Firstname must be at most 20 characters';

    }

  }
}