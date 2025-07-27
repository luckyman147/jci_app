

import 'package:dartz/dartz.dart';

import '../../AuthWidgetGlobal.dart';

abstract class UserStatusRepo {
  Future<Either<Failure, bool>> isFirstEntry();
  Future<Either<Failure, bool>> isLoggedIn();
  Future<Either<Failure, bool>> isNewMember();
  Future<Either<Failure, Unit>> updateFirstEntry();
  Future<Either<Failure, Unit>> updateLoggedIn(bool value);
  Future<Either<Failure, Unit>> updateTokenFromStorage();
  Future<Either<Failure, bool>> isEmailVerified();
  Future<Either<Failure, bool>> isPhoneVerified();
  Future<Either<Failure, String>> getPreviousEmail();

  Future<Either<Failure, Unit>> updateUserVerificationStatus();


}
