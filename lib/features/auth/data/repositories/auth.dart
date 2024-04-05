import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Exception.dart';

import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/network/network_info.dart';
import 'package:jci_app/features/auth/data/datasources/authRemote.dart';
import 'package:jci_app/features/auth/data/models/Member/AuthModel.dart';

import 'package:jci_app/features/auth/domain/entities/Member.dart';




import '../../domain/repositories/AuthRepo.dart';
import '../datasources/authLocal.dart';
typedef Future<bool> Auth();
typedef Future<Unit> ResetPassword();
class AuthRepositoryImpl implements AuthRepo {
final AuthLocalDataSources local;
  final AuthRemote api ;
final NetworkInfo networkInfo;
  AuthRepositoryImpl( {required this.api,required this.networkInfo, required this.local});

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
  Future<Either<Failure,Unit >> refreshToken() async {
    return _getMessageReset(api.refreshToken());
  }



  @override
  Future<Either<Failure, MemberModel>> sendPasswordResetEmail(String email) {
    // TODO: implement sendPasswordResetEmail
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> signOut() {
return _getMessage(api.signOut());
  }

  @override
  Future<Either<Failure, Unit>> updatePassword(Member member) {
final MemberModel memberModel=MemberModel.fromEntity(member);



      return _getMessageReset(api.updatePassword(memberModel));
  }

  @override
  Future<Either<Failure, Member>> verifyEmail() {
    // TODO: implement verifyEmail
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> isFirstEntry()async  {
    return _getMessage(local.isFirstEntry());
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() {
    return _getMessage(local.isLoggedIn());
  }

  @override
  Future<Either<Failure, Unit>> updateFirstEntry() {
return _getMessageReset(local.updateFirstEntry());
  }

  @override
  Future<Either<Failure, Unit>> updateLoggedIn(bool value) {
    return _getMessageReset(local.updateLoggedIn(value));
  }

  @override
  Future<Either<Failure, Unit>> updateTokenFromStorage() {
    // TODO: implement updateTokenFromStorage
    throw UnimplementedError();
  }




}