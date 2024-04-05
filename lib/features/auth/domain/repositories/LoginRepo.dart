import 'package:dartz/dartz.dart';
import 'package:jci_app/features/auth/domain/entities/Member.dart';

import '../../../../core/error/Failure.dart';

abstract class LoginRepo{
  Future<Either<Failure, Map>> LogInWithGoogle();
  Future<Either<Failure, Map>> LogInWithFacebook();

  Future<Either<Failure, Unit>> LogInWithCredentials(String email, String password);
}