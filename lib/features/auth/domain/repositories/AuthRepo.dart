
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:jci_app/features/auth/domain/entities/Member.dart';
import '../../../../core/error/Failure.dart';


abstract class AuthRepo {



  Future<Either<Failure, bool>> signOut(bool isGoogle);
Future<Either<Failure,bool>> isFirstEntry();
  Future<Either<Failure,Unit>> updateLoggedIn(bool value);
  Future<Either<Failure,Unit>> updateTokenFromStorage();
  Future<Either<Failure,Unit>> updateFirstEntry();
  Future<Either<Failure,bool>> isLoggedIn();
  Future<Either<Failure,bool>> isNewMember();


  Future<Either<Failure, Unit>> updatePassword(Member member);
  Future<Either<Failure, Unit>> signUpWithCredentials(Member member,String otp);
  Future<Either<Failure, Unit>> LogInWithCredentials(String email ,String password);
  Future<Either<Failure,Unit>> refreshToken();
Future<Either<Failure,Unit>> SendVerificationEmail(String email);
Future<Either<Failure,Unit>> SendResetPasswordEmail(String email);
Future<Either<Failure,bool>> checkOtp(String otp);
Future<Either<Failure,User?>> signinWithGoogle();
Future<Either<Failure,Unit>> RegisterInWithGoogle(Member member);
}