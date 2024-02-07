import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/features/auth/domain/entities/LoginMember.dart';
import 'package:jci_app/features/auth/domain/entities/Member.dart';
import 'package:jci_app/features/auth/domain/repositories/LoginRepo.dart';

import '../repositories/AuthRepo.dart';
import 'Authentication.dart';

class LoginUseCase{
  final LoginRepo _loginRepo;

  LoginUseCase  (this._loginRepo);

  Future<Either<Failure, Map>> LoginCredentials(LoginMember loginMember) async {
    return await _loginRepo.LogInWithCredentials(loginMember);
  }
  Future<Either<Failure, Map>> LoginGoogle() async {
    return await _loginRepo.LogInWithGoogle();
  }
  Future<Either<Failure, Map>> LoginFacebook() async {
    return await _loginRepo.LogInWithFacebook();
  }
}