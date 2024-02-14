import 'package:formz/formz.dart';
import 'package:flutter/services.dart';

enum EmailValidationError { empty, invalid }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
  );

  @override
  EmailValidationError? validator(String value) {

    if (!_emailRegExp.hasMatch(value)) return EmailValidationError.invalid;
    return null;
  }

  bool get isValidEmail => _emailRegExp.hasMatch(value);
}
