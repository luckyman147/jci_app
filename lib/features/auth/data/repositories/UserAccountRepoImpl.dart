import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:jci_app/core/Handlers/Handler.dart';
import 'package:jci_app/core/Member.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/core/error/Failure.dart';

import 'package:jci_app/core/strings/SecureMessgaes.dart';
import 'package:jci_app/features/auth/data/datasources/UserAccountRemote.dart';

import 'package:jci_app/features/auth/domain/repositories/UserAccountRepo.dart';

import '../../../../core/Handlers/IHandler.dart';
import '../../domain/dtos/ResetpasswordDtos.dart';

class UserAccountRepoIml implements UserAccountRepo{
  final Handler<Unit> handler;
  final UserAccountDataSource userAccountDataSource;


  UserAccountRepoIml( {required this.handler, required this.userAccountDataSource});
  @override
  Future<Either<Failure, Unit>> checkOtp(String otp) {
    return handler.handle(
      onCall: () async {
        final result = await userAccountDataSource.checkOtp(otp);
        return result;
      },
      onError: (e) {
        return (e as Exception).get_failure;
      },
    ) ;
  }
  @override
  Future<Either<Failure, Unit>> refreshToken() async {


    // Await the result of handlers.handle
    return   handler.handle(
      onCall: () async {


        // Attempt to refresh the token
        final result =   await userAccountDataSource.refreshToken();
        return result; // Assuming this returns Either<Failure, Unit>
      },
      onError: (e) {
        if (e is Exception) {
          return e.get_failure; // Ensure get_failure returns a Failure type
        }
        throw e; // Rethrow unexpected errors
      },
    ) ; // Cast the result to Either<Failure, Unit>
  }


  @override
  Future<Either<Failure, Unit>> sendResetPasswordEmail(String email) {
    return handler.handle(
      onCall: () async {

        final result = await userAccountDataSource.sendResetPasswordEmail(email);
        return result;
      },
      onError: (e) {
        return (e as Exception).get_failure;
      },
    ) ;
  }

  @override
  Future<Either<Failure, Unit>> sendVerificationEmail(String email) {

    return handler.handle(
      onCall: () async {
        final otp=SecureMessages().generateSecureOTP();
        final result = await userAccountDataSource.sendVerificationEmail(email,otp);

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
  Future<Either<Failure, Unit>> updatePassword(ResetpasswordDtos member)async {
    return handler.handle(
      onCall: () async {
        final result = await userAccountDataSource.updatePassword(member.email,member.password);
        return result;
      },
      onError: (e) {
        return (e as Exception).get_failure;
      },
    ) ;
  }

  @override
  Future<Either<Failure, Unit>> VerifyExpirationToken() async{
    return handler.handle(
      onCall: () async {
        final result = await userAccountDataSource.isTokenExpired();
        return result;
      },
      onError: (e) {
        return (e as Exception).get_failure;
      },
    ) as Either<Failure, Unit>;

  }

  @override
  Future<Either<Failure, Unit>> startPhoneVerification(String phoneNumber)async {
   throw UnimplementedError();
  }
}