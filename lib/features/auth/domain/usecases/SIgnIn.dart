import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/features/auth/domain/entities/Member.dart';

import 'package:jci_app/features/auth/domain/repositories/LoginRepo.dart';

import '../../../../core/usescases/usecase.dart';



class LoginUseCase{
  final LoginRepo _loginRepo;

  LoginUseCase  (this._loginRepo);

  Future<Either<Failure, Unit>> LoginCredentials(Member loginMember) async {
    return await _loginRepo.LogInWithCredentials(loginMember);
  }
  Future<Either<Failure, Map>> LoginGoogle() async {
    return await _loginRepo.LogInWithGoogle();
  }
  Future<Either<Failure, Map>> LoginFacebook() async {
    return await _loginRepo.LogInWithFacebook();
  }
}
