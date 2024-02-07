import 'package:dartz/dartz.dart';
import 'package:jci_app/features/auth/domain/repositories/SignUpRepo.dart';

import '../../../../core/error/Failure.dart';
import '../entities/Member.dart';
import '../repositories/AuthRepo.dart';

class SignUpUseCase{
final SignUpRepo authRepo;

  SignUpUseCase({required this.authRepo});
  Future<Either<Failure,String>> SignUpCred(MemberSignUp member) async {
    return await authRepo.signUpWithCredentials(member);
  }
  Future<Either<Failure,Unit>> SignUpGoogle() async {
    return await authRepo.signUpWithGoogle();
  }
  Future<Either<Failure,Unit>> SignUpFacebook() async {
    return await authRepo.signUpWithFacebook();
  }




}