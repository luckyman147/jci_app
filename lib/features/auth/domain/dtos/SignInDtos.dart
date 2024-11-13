import '../entities/AuthUser.dart';


class SignInDtos{
  final AuthUser? member;
  final String otp;
  final String? email;


  SignInDtos({required this.member, required this.otp, required this.email});

}