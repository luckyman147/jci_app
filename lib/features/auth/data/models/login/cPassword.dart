import 'package:formz/formz.dart';
import 'package:jci_app/features/auth/data/models/login/password.dart';

enum ConfirmPasswordValidationError { empty, notEqual }

class ConfirmPassword extends FormzInput<String, ConfirmPasswordValidationError> {

  const ConfirmPassword.pure() : super.pure('');
  const ConfirmPassword.dirty( [super.value = '']) : super.dirty();

  @override
  ConfirmPasswordValidationError? validator(String value) {
    if (value.isEmpty) return ConfirmPasswordValidationError.empty;

    return null;
  }
}


