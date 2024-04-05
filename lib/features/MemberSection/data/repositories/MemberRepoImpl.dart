import 'package:dartz/dartz.dart';

import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/features/MemberSection/data/datasources/MemberLocalDataSources.dart';
import 'package:jci_app/features/MemberSection/data/datasources/MemberRemoteDataSources.dart';

import 'package:jci_app/features/auth/domain/entities/Member.dart';

import '../../../../core/error/Exception.dart';
import '../../../../core/network/network_info.dart';
import '../../../auth/data/datasources/authLocal.dart';
import '../../../auth/data/models/Member/AuthModel.dart';
import '../../domain/repositories/MemberRepo.dart';

class MemberRepoImpl extends MemberRepo {
  final MemberRemote memberRemote;
  final MemberLocalDatasoources membersLocalDataSource;
  final NetworkInfo networkInfo;

  MemberRepoImpl({required this.memberRemote, required this.networkInfo, required this.membersLocalDataSource});

  @override
  Future<Either<Failure, Unit>> UpdateCotisation(String memberid, List<bool> cotisation) {
    // TODO: implement UpdateCotisation
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> UpdatePoints(String memberid, double points) {
    // TODO: implement UpdatePoints
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMember(String id) {
    // TODO: implement deleteMember
    throw UnimplementedError();
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
  Future<Either<Failure, Member>> GetUserProfile(bool isUpdated) async{

    if (await networkInfo.isConnected) {
      try {
        if (!isUpdated) {
          final members = await membersLocalDataSource.getUserProfile();
          if (members == null) {
            final members = await memberRemote.getUserProfile();
            membersLocalDataSource.ChangeUserProfile(members);
            return Right(members);
          }
          return Right(members);
        }

        else{



        final members = await memberRemote.getUserProfile();
        membersLocalDataSource.ChangeUserProfile(members);

        return Right(members);}
      } on ServerException {
        return Left(ServerFailure());
      }
      on UnauthorizedException {
        return Left(UnauthorizedFailure());
      }
    } else {
     final members = await membersLocalDataSource.getUserProfile();
      return Right(members!);

    }
  }

  @override
  Future<Either<Failure, Member>> getMember(String id) {
    // TODO: implement getMember
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure,Unit>> updateMember(Member member) {
   final membermodel=MemberModel.fromEntity(member);
   return _getMessageReset(memberRemote.UpdateMember(membermodel));
  }
  @override
  Future<Either<Failure, List<Member>>> GetMemberByName(String name)async {
    if (await networkInfo.isConnected) {
      try {
        final members = await memberRemote.GetmMemberByName(name);

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
  @override
  Future<Either<Failure, List<Member>>> GetMembers() async {
    if (await networkInfo.isConnected) {
      try {
        final members = await memberRemote.GetMembers();
        membersLocalDataSource.CacheMembers(members);
        return Right(members);
      } on ServerException {
        return Left(ServerFailure());
      }
      on UnauthorizedException {
        return Left(UnauthorizedFailure());
      }
    } else {
      try {
        final members = await membersLocalDataSource.GetMembers();
        return Right(members);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }

    }
  }

  }


