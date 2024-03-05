import 'package:dartz/dartz.dart';
import 'package:jci_app/features/auth/domain/entities/Member.dart';

import '../../../../core/error/Failure.dart';


abstract class SignUpRepo {
  Future<Either<Failure,Unit>> signUpWithCredentials(Member member);
  Future<Either<Failure, Unit>> signUpWithGoogle();
  Future<Either<Failure, Unit>> signUpWithFacebook();

}