import 'dart:developer';

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
import '../../presentation/bloc/memberBloc/member_management_bloc.dart';

class MemberRepoImpl extends MemberRepo {
  final MemberRemote memberRemote;
  final MemberLocalDatasoources membersLocalDataSource;
  final NetworkInfo networkInfo;

  MemberRepoImpl({required this.memberRemote, required this.networkInfo, required this.membersLocalDataSource});

  @override
  Future<Either<Failure, Unit>> UpdateCotisation(String memberid, int type, bool cotisation) {
    return _getMessageReset(memberRemote.validateCotisation(memberid, type, cotisation));
  }

  @override
  Future<Either<Failure, Unit>> UpdatePoints(String memberid, double points) {
 return _getMessageReset(memberRemote.UpdatePoints(memberid, points, ));
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
            log("hhhhhhh"+members.Activities.toString());

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
  Future<Either<Failure, Member>> getMemberByid(String id,bool status)async  {
    if (await networkInfo.isConnected) {
      try {
         if ( status==true ||(await membersLocalDataSource.getMemberById(id)==null && status==false)){
           log("hahaha");

           final members = await memberRemote.getMemberByid(id);
        await membersLocalDataSource.saveMemberByID(members,id);
        return Right(members);

         }
          else {
            log("ddddssssssss");
            final members = await membersLocalDataSource.getMemberById(id);
            return Right(members!);
          }


      } on ServerException {
        return Left(ServerFailure());
      }
      on UnauthorizedException {
        return Left(UnauthorizedFailure());
      }
    } else {
      log("dddd");

      final members = await membersLocalDataSource.getMemberById(id);
      if (members==null){
        return Left(EmptyCacheFailure());
      }
      return Right(members);
    }

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
        final members = await membersLocalDataSource.GetMembers();
        if (members.isEmpty) {
          final members = await memberRemote.GetMembers();
          membersLocalDataSource.CacheMembers(members);
          return Right(members);
        }
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

  @override
  Future<Either<Failure, Unit>> validateMember(String memberid) {
     return _getMessageReset(memberRemote.validateMember(memberid));
  }

  @override
  Future<Either<Failure, Unit>> ChangeToAdmin(String id,MemberType type) {
    if (type==MemberType.admin){
      return _getMessageReset(memberRemote.ChangeToAdmin(id));
    }
    else if (type==MemberType.member){
      return _getMessageReset(memberRemote.ChangeToMember(id));
    }
    else{
    return _getMessageReset(memberRemote.ChangeToSuperAdmin(id));}
  }

  }

