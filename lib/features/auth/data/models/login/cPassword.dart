import 'package:formz/formz.dart';
import 'package:jci_app/features/auth/data/models/login/password.dart';

enum ConfirmPasswordValidationError { empty, notEqual }

class ConfirmPassword extends FormzInput<String, ConfirmPasswordValidationError> {
  const ConfirmPassword.pure({required this.password}) : super.pure('');
  const ConfirmPassword.dirty({required this.password,  required String? value}) : super.dirty(value ?? '');

  final Password password;

  @override
  ConfirmPasswordValidationError? validator(String value) {
if (value.isEmpty) return ConfirmPasswordValidationError.empty;
  else  if (value != password.value) return ConfirmPasswordValidationError.notEqual;
    return null;
  }
}
extension on ConfirmPasswordValidationError {
  String text() {
    switch (this) {
      case ConfirmPasswordValidationError.notEqual:
        return 'Passwords do not match';
      case ConfirmPasswordValidationError.empty:
        return 'Please enter an password';
    }
  }
}