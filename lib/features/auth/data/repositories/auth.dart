import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Exception.dart';

import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/network/network_info.dart';
import 'package:jci_app/features/auth/data/datasources/authRemote.dart';

import 'package:jci_app/features/auth/domain/entities/Member.dart';


import '../../domain/repositories/AuthRepo.dart';
typedef Future<bool> Auth();

class AuthRepositoryImpl implements AuthRepo {
  final AuthRemote api ;
final NetworkInfo networkInfo;
  AuthRepositoryImpl( {required this.api,required this.networkInfo});

  Future<Either<Failure, bool>> _getMessage(
      Future<bool> Auth) async {
    if (await networkInfo.isConnected) {
      try {
        await Auth;
        return Right(true);
      }

    on EmptyCacheException{
      return Left(EmptyCacheFailure());}

    } else {
      return Left(OfflineFailure());
    }
  }


  @override
  Future<Either<Failure,bool>> refreshToken() async {
    return  await _getMessage( api.refreshToken());
  }

  @override
  Future<Either<Failure, MemberSignUp>> deleteAccount() {
    // TODO: implement deleteAccount
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, MemberSignUp>> sendPasswordResetEmail(String email) {
    // TODO: implement sendPasswordResetEmail
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, MemberSignUp>> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, MemberSignUp>> updatePassword(String password) {
    // TODO: implement updatePassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, MemberSignUp>> verifyEmail() {
    // TODO: implement verifyEmail
    throw UnimplementedError();
  }
}