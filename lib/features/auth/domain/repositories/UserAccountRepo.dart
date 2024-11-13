import 'package:dartz/dartz.dart';


import '../../../../core/error/Failure.dart';
import '../dtos/ResetpasswordDtos.dart';

abstract class UserAccountRepo {
  Future<Either<Failure, Unit>> updatePassword(ResetpasswordDtos member);
  Future<Either<Failure, Unit>> sendVerificationEmail(String email);
  Future<Either<Failure, Unit>> sendResetPasswordEmail(String email);
  Future<Either<Failure, Unit>> checkOtp(String otp);
  Future<Either<Failure, Unit>> refreshToken();
  Future<Either<Failure, Unit>> VerifyExpirationToken();
  Future<Either<Failure, Unit>> startPhoneVerification(String phoneNumber);






}
