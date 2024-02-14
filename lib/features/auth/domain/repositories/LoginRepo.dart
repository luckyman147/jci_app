import 'package:dartz/dartz.dart';
import 'package:jci_app/features/auth/domain/entities/LoginMember.dart';

import '../../../../core/error/Failure.dart';

abstract class LoginRepo{
  Future<Either<Failure, Map>> LogInWithGoogle();
  Future<Either<Failure, Map>> LogInWithFacebook();

  Future<Either<Failure, Unit>> LogInWithCredentials(Member loginMember);
}