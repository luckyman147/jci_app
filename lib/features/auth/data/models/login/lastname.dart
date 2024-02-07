import 'package:formz/formz.dart';

enum LastnameValidationError { empty, tooShort, tooLong }

class Lastname extends FormzInput<String, LastnameValidationError> {
  const Lastname.pure() : super.pure('');
  const Lastname.dirty([super.value = '']) : super.dirty();

  static final _minLength = 6;
  static final _maxLength = 20;

  @override
  LastnameValidationError? validator(String value) {
    if (value.isEmpty) return LastnameValidationError.empty;
  else  if (value.length < _minLength) return LastnameValidationError.tooShort;
    else if (value.length > _maxLength) return LastnameValidationError.tooLong;
    return null;
  }
}
extension on LastnameValidationError {
  String text() {
    switch (this) {
      case LastnameValidationError.tooShort:
        return ' Lastname must be at least 6 characters';
      case LastnameValidationError.empty:
        return 'Please enter a lastname';
      case LastnameValidationError.tooLong:
        return 'Lastname must be at most 20 characters';
    }}}
