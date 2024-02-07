import 'dart:async';



import 'package:jci_app/features/auth/domain/entities/Member.dart';


class MemberRepository {
  MemberSignUp? _member;

  Future<MemberSignUp?> getMember() async {
    if (_member != null) return _member;
    return Future.delayed(
      const Duration(milliseconds: 300),
          () => _member = MemberSignUp( email: '', password: '', FirstName: '', LastName: ''),
    );
  }
}