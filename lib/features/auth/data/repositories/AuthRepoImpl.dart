import 'package:dartz/dartz.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:jci_app/core/Handlers/Handler.dart';
import 'package:jci_app/core/error/Exception.dart';

import 'package:jci_app/core/error/Failure.dart';

import 'package:jci_app/features/auth/domain/dtos/LoginWithEmailDto.dart';

import 'package:jci_app/features/auth/domain/dtos/LoginWithPhoneDto.dart';

import 'package:jci_app/features/auth/domain/dtos/SignInDtos.dart';
import 'package:logger/logger.dart';

import '../../domain/repositories/AuthRepo.dart';

import '../../domain/repositories/UserAccountRepo.dart';
import '../datasources/authRemote.dart';

class AuthRepositoryImpl implements AuthRepo {
  final Handler<Unit> handler;
  final Logger logger= Logger();

  final AuthRemote api ;
  final UserAccountRepo userAccountRepoIml;
  AuthRepositoryImpl( this.api, this.userAccountRepoIml, {required this.handler});
  @override
  Future<Either<Failure, Unit>> RegisterWithEmail(SignInDtos signin)async {

  return  handler.handle(
      onCall: () async {

        await userAccountRepoIml.checkOtp(signin.otp);
        final result = await api.RegisterWithEmail(signin);
        return result;

      },
      onError: (e) {
        logger.e(e);
        if (e is Exception) {
          return e.get_failure;
        }
    throw e;
      },

    )
  ;

  }
  @override
  Future<Either<Failure, Unit>> RegisterWithPhone(SignInDtos signin) async{
    return  handler.handle(
      onCall: () async {
        final result = await api.RegisterWithPhone(signin);
        return result;

      },
      onError: (e) {
        return (e as Exception).get_failure;
      },

    ) as Either<Failure, Unit>;

  }

  @override
  Future<Either<Failure, Unit>> logInWithEmail(LoginWithEmailDtos login) async{
    return  handler.handle(
      onCall: () async {
        final result = await api.logInWithEmail(login);

        return result;

      },
      onError: (e) {
        if (e is Exception) {
          return e.get_failure;
        }
        throw e;
      },

    ) ;

  }

  @override
  Future<Either<Failure, Unit>> logInWithPhone(LoginWithPhoneDtos login) async {
    return  handler.handle(
      onCall: () async {
        final result = await api.logInWithPhone(login);
        return result;

      },
      onError: (e) {
        if (e is Exception) {
          return e.get_failure;
        }
        throw e;
      },

    ) as Either<Failure, Unit>;
  }

  @override
  Future<Either<Failure, Unit>> signInWithGoogle() async{

    return  handler.handle(
      onCall: () async {
        final result = await api.signInWithGoogle();
        return result;

      },
      onError: (e) {
        if (e is Exception) {
          return e.get_failure;
        }
        throw e;
      },

    ) ;

  }

  @override
  Future<Either<Failure, Unit>> signOut(bool isGoogle) async{

    return  handler.handle(
      onCall: () async {
        final result = await api.signOut(isGoogle);
        return result;

      },
      onError: (e) {
        return (e as Exception).get_failure;
      },

    ) ;

  }

}