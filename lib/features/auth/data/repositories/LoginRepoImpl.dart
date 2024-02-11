  import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Exception.dart';


import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/network/network_info.dart';
import 'package:jci_app/features/auth/data/datasources/LoginRemote.dart';

import 'package:jci_app/features/auth/data/models/MemberModel.dart';
import 'package:jci_app/features/auth/domain/entities/LoginMember.dart';


import 'package:jci_app/features/auth/domain/repositories/LoginRepo.dart';


typedef Future<Unit> LogIn();
class LoginRepoImpl implements LoginRepo {

  final LoginRemoteDataSource loginRemoteDataSource;
  final NetworkInfo networkInfo;

  LoginRepoImpl({ required this.loginRemoteDataSource,required this.networkInfo});
  @override



  Future<Either<Failure, Unit>> _getMessage(
      Future<Unit> logIn) async {
    if (await networkInfo.isConnected) {
      try {
        await logIn;
        return Right(unit);
      }

      on WrongCredentialsException{
        return Left(WrongCredentialsFailure());
      }

    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> LogInWithCredentials(LoginMember loginMember) async {





        final MemberModelLogin memberModelLogin=MemberModelLogin(email: loginMember.email, password: loginMember.password);
        final message= loginRemoteDataSource.Login(memberModelLogin );
    return  await _getMessage(message);



  }

  @override
  Future<Either<Failure, Map>> LogInWithFacebook() {
    // TODO: implement LogInWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Map>> LogInWithGoogle() {
    // TODO: implement LogInWithGoogle
    throw UnimplementedError();
  }
  }


