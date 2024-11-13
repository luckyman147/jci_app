import 'package:dartz/dartz.dart';
import 'package:jci_app/core/Handlers/Handler.dart';
import 'package:jci_app/core/error/Exception.dart';

import 'package:jci_app/core/error/Failure.dart';

import '../../domain/repositories/UserStatusRepo.dart';
import '../datasources/UserStatusRemote.dart';

class UserStatusRepoImpl implements UserStatusRepo {
  final UserStatusRemoteDataSource userStatusRemoteDataSource;
  final Handler<bool> handler;

  UserStatusRepoImpl(this.handler, {required this.userStatusRemoteDataSource});

  @override
  Future<Either<Failure, bool>> isEmailVerified() {
    // TODO: implement isEmailVerified
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> isFirstEntry() {
    // TODO: implement isFirstEntry
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async{
    return await handler.handle
      (onCall: (){

      final result =
        userStatusRemoteDataSource.isLoggedIn();
      return result;

      }

        ,
        onError: (e) {
    if (e is Exception) {
      return e.get_failure;
    } else {
      throw e;
    }}
    );
    // TODO: implement isLoggedIn
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> isNewMember() {
    // TODO: implement isNewMember
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> isPhoneVerified() {
    // TODO: implement isPhoneVerified
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> updateFirstEntry() {
    // TODO: implement updateFirstEntry
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> updateLoggedIn(bool value) {
    // TODO: implement updateLoggedIn
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> updateTokenFromStorage() {
    // TODO: implement updateTokenFromStorage
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> updateUserVerificationStatus() {
    // TODO: implement updateUserVerificationStatus
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> getPreviousEmail()async {
    try{
      return Right(await userStatusRemoteDataSource.getPreviousEmail());
    }catch(e){
      throw NotFoundFailure();
    }

  }

}