import 'package:formz/formz.dart';

enum PhoneNumberValidationError { empty,invalid }

class PhoneNumber extends FormzInput<String, PhoneNumberValidationError> {
  const PhoneNumber.pure([super.value = '']) : super.pure();
  const PhoneNumber.dirty([super.value = '']) : super.dirty();

  @override
  PhoneNumberValidationError? validator(String value) {
    if (value.isEmpty) {
      return PhoneNumberValidationError.empty;
    } else if (value.length !=8) {
      return PhoneNumberValidationError.invalid;
    }

    return null;
  }
}
extension on PhoneNumberValidationError {
  String text() {
    switch (this) {
      case PhoneNumberValidationError.invalid:
        return '''PhoneNumber must be at least 8 number and contain at least one letter and number''';
      case PhoneNumberValidationError.empty:
        return 'Please enter a PhoneNumber';
    }
  }
}