import 'package:formz/formz.dart';


enum ConfirmPasswordValidationError { empty, notEqual }

class ConfirmPassword extends FormzInput<String, ConfirmPasswordValidationError> {

  const ConfirmPassword.pure() : super.pure('');
  const ConfirmPassword.dirty( [super.value = '']) : super.dirty();

  @override
  ConfirmPasswordValidationError? validator(String value) {
    if (value.isEmpty) return ConfirmPasswordValidationError.empty;

    //verify if the password is equal to the confirm password


    return null;
  }
}


