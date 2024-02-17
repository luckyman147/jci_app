import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Exception.dart';

import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/network/network_info.dart';
import 'package:jci_app/features/auth/data/datasources/authRemote.dart';
import 'package:jci_app/features/auth/data/models/login/MemberModel.dart';
import 'package:jci_app/features/auth/domain/entities/LoginMember.dart';

import 'package:jci_app/features/auth/domain/entities/Member.dart';


import '../../domain/repositories/AuthRepo.dart';
typedef Future<bool> Auth();
typedef Future<Unit> ResetPassword();
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

      on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
      catch (e) {
        return Left(ServerFailure());
      }
    }

      else {
        return Left(OfflineFailure());
      }
  }
    Future<Either<Failure, Unit>> _getMessageReset(
      Future<Unit> AuthReset) async {
    if (await networkInfo.isConnected) {
      try {
        await AuthReset;
        return Right(unit);
      }


      catch(e){

        return Left(ServerFailure());
      }

    }


    else {
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
  Future<Either<Failure, bool>> signOut() {
return _getMessage(api.signOut());
  }

  @override
  Future<Either<Failure, Unit>> updatePassword(Member member) {
final MemberModel memberModel=MemberModel(email: member.email, password: member.password);

      return _getMessageReset(api.updatePassword(memberModel));
  }

  @override
  Future<Either<Failure, MemberSignUp>> verifyEmail() {
    // TODO: implement verifyEmail
    throw UnimplementedError();
  }
}