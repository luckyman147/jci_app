
import 'package:dartz/dartz.dart';

import 'package:jci_app/features/auth/domain/dtos/LoginWithEmailDto.dart';
import 'package:jci_app/features/auth/domain/dtos/LoginWithPhoneDto.dart';
import '../../../../core/error/Failure.dart';
import '../dtos/SignInDtos.dart';


abstract class AuthRepo {
  Future<Either<Failure, Unit>> signOut(bool isGoogle);
  Future<Either<Failure, Unit>> RegisterWithEmail(SignInDtos signin);
  Future<Either<Failure, Unit>> logInWithEmail(LoginWithEmailDtos login);
  Future<Either<Failure, Unit>> RegisterWithPhone(SignInDtos signin);
  Future<Either<Failure, Unit>> logInWithPhone(LoginWithPhoneDtos login);
  Future<Either<Failure, Unit>> signInWithGoogle();
}
