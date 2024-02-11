import 'package:dartz/dartz.dart';

import '../../../../core/error/Failure.dart';
import '../entities/Member.dart';

abstract class SignUpRepo {
  Future<Either<Failure,Unit>> signUpWithCredentials(MemberSignUp member);
  Future<Either<Failure, Unit>> signUpWithGoogle();
  Future<Either<Failure, Unit>> signUpWithFacebook();

}