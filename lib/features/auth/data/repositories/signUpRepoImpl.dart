import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Exception.dart';

import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/network/network_info.dart';
import 'package:jci_app/features/auth/data/datasources/signUpRemote.dart';
import 'package:jci_app/features/auth/data/models/MemberSIgnUP/MerberSignUp.dart';
import 'package:jci_app/features/auth/domain/entities/Member.dart';


import '../../domain/repositories/SignUpRepo.dart';

typedef Future<Unit> SignUP();
class SignUpRepoImpl implements SignUpRepo {
  final SignUpRemoteDataSource signUpRemoteDataSource;
  final NetworkInfo networkInfo;

  SignUpRepoImpl(this.signUpRemoteDataSource, this.networkInfo);
  @override

  Future<Either<Failure, Unit>> signUpWithCredentials(Member member)async  {


        final MemberSignup memberModelSignUp=MemberSignup(
          teams: member.teams,
          email: member.email,
          password: member.password,
          firstName: member.firstName,
          phone: member.phone,
          role: "user",
          lastName: member.lastName, id: "", is_validated: false, cotisation: [false], Images: [], IsSelected: false, Activities: [], points: 0, objectifs: [],);
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
