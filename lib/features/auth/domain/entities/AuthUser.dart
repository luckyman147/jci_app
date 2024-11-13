import 'package:jci_app/core/Member.dart';

import '../../../../core/PrimitiveUser/User.dart';

class AuthUser extends User{
  final String language;
  final String password;

  final bool isEmailVerified;
  AuthUser( {required super.email, required super.firstName, required super.lastName, required super.Images, required super.role,
    required this.language, required this.password, required this.isEmailVerified});

  factory AuthUser.SignUp({required String email, required String firstName, required String lastName,  required String language, required String password}) {
    return AuthUser(
      email: email,
      firstName: firstName,
      lastName: lastName,
      Images: [],
      role: null, language: language, password: password, isEmailVerified: false
    );}
}