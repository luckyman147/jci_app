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
  final MembersLocalDataSource membersLocalDataSource;
  final AuthRemote api ;
final NetworkInfo networkInfo;
  AuthRepositoryImpl( {required this.api,required this.networkInfo, required this.membersLocalDataSource});

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

  @override  Future<Either<Failure, MemberModel>> deleteAccount() {
    // TODO: implement deleteAccount
    throw UnimplementedError();
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
final MemberModel memberModel=MemberModel(email: member.email, password: member.password, id: member.id,
    firstName: member.firstName, phone: member.phone, role: member.role, is_validated: member.is_validated, lastName: member.lastName, cotisation: member.cotisation, Images: member.Images, IsSelected: false, Activities: member.Activities,


);

      return _getMessageReset(api.updatePassword(memberModel));
  }

  @override
  Future<Either<Failure, Member>> verifyEmail() {
    // TODO: implement verifyEmail
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> GetUserProfile() {

      return _getMessageReset(api.
          getUserProfile());

  }

  @override
  Future<Either<Failure, List<Member>>> GetAllMembers() async {
    if (await networkInfo.isConnected) {
      try {
        final members = await api.GetMembers();
membersLocalDataSource.cacheMembers(members);
        return Right(members);
      } on ServerException {
        return Left(ServerFailure());
      }
      on UnauthorizedException {
        return Left(UnauthorizedFailure());
      }
    } else {
      try {
        final members = await membersLocalDataSource.getAllCachedmembers();
        return Right(members);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }

    }
  }

  @override
  Future<Either<Failure, List<Member>>> GetMemberByName(String name)async {
    if (await networkInfo.isConnected) {
      try {
        final members = await api.GetmMemberByName(name);

        return Right(members);
      } on ServerException {
        return Left(ServerFailure());
      }
      on UnauthorizedException {
        return Left(UnauthorizedFailure());
      }
    } else {
      return Left(OfflineFailure());

    }
  }

}