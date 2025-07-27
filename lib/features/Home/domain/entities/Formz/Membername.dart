import 'package:formz/formz.dart';

import '../../../../../core/PrimitiveUser/User.dart';

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

class MemberFormz extends FormzInput<User?, MemberFormzValidationError> {
  const MemberFormz.pure() : super.pure(null);
  const MemberFormz.dirty(User? value) : super.dirty(value);

  @override
  MemberFormzValidationError? validator(User? value) {
    if (value == null) return MemberFormzValidationError.empty;

    return null;
  }
}enum MembersTeamFormzValidationError { empty }

class MembersTeamFormz extends FormzInput<List<User>?,MembersTeamFormzValidationError> {
  const MembersTeamFormz.pure() : super.pure(null);
  const MembersTeamFormz.dirty(List<User>? value) : super.dirty(value);

  @override
  MembersTeamFormzValidationError? validator(List<User>? value) {
    if (value == null) return MembersTeamFormzValidationError.empty;

    return null;
  }
}
