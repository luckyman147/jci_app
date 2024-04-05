
import 'package:dartz/dartz.dart';
import 'package:jci_app/features/auth/domain/entities/Member.dart';
import '../../../../core/error/Failure.dart';


abstract class AuthRepo {



  Future<Either<Failure, bool>> signOut();
Future<Either<Failure,bool>> isFirstEntry();
  Future<Either<Failure,Unit>> updateLoggedIn(bool value);
  Future<Either<Failure,Unit>> updateTokenFromStorage();
  Future<Either<Failure,Unit>> updateFirstEntry();
  Future<Either<Failure,bool>> isLoggedIn();
  Future<Either<Failure, Member>> sendPasswordResetEmail(String email);
  Future<Either<Failure, Member>> verifyEmail();
  Future<Either<Failure, Unit>> updatePassword(Member member);

  Future<Either<Failure,Unit>> refreshToken();

}