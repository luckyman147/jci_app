import 'package:jci_app/features/auth/domain/dtos/SignInDtos.dart';

class CheckOTPDtos{
final String otp;
  final SignInDtos signin;

  CheckOTPDtos({required this.otp, required this.signin});
}