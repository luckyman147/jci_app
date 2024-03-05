import 'package:formz/formz.dart';
import 'package:jci_app/features/auth/domain/entities/Member.dart';

enum MemberNameValidationError { empty }

class MemberName extends FormzInput<String, MemberNameValidationError> {

  const MemberName.pure() : super.pure('');
  const MemberName.dirty( [super.value = '']) : super.dirty();

  @override
  MemberNameValidationError? validator(String value) {
    if (value.isEmpty) return MemberNameValidationError.empty;

    return null;
  }
}
enum MemberFormzValidationError { empty }

class MemberFormz extends FormzInput<Member?, MemberFormzValidationError> {
  const MemberFormz.pure() : super.pure(null);
  const MemberFormz.dirty(Member? value) : super.dirty(value);

  @override
  MemberFormzValidationError? validator(Member? value) {
    if (value == null) return MemberFormzValidationError.empty;

    return null;
  }
}