import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Exception.dart';

import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/network/network_info.dart';
import 'package:jci_app/features/auth/data/datasources/signUpRemote.dart';
import 'package:jci_app/features/auth/data/models/MemberModel.dart';

import 'package:jci_app/features/auth/domain/entities/Member.dart';

import '../../domain/repositories/SignUpRepo.dart';
typedef Future<Unit> SignUP();
class SignUpRepoImpl implements SignUpRepo {
  final SignUpRemoteDataSource signUpRemoteDataSource;
  final NetworkInfo networkInfo;

  SignUpRepoImpl(this.signUpRemoteDataSource, this.networkInfo);
  @override

  Future<Either<Failure, Unit>> signUpWithCredentials(MemberSignUp member)async  {


        final MemberModelSignUp memberModelSignUp=MemberModelSignUp(email: member.email, password: member.password, FirstName: member.FirstName, LastName: member.LastName, confirmPassword: member.confirmPassword);
  return    await  getMessage   (signUpRemoteDataSource.signUp(memberModelSignUp ) );











}
  Future<Either<Failure, Unit>> getMessage(
      Future<Unit> signUP) async {
    if (await networkInfo.isConnected) {
      try {
        await signUP;
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
      on IsEmailException {
        return Left(EmailExistedFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> signUpWithFacebook() {
    // TODO: implement signUpWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> signUpWithGoogle() {
    // TODO: implement signUpWithGoogle
    throw UnimplementedError();
  }
}
