import 'dart:developer';

import 'package:dartz/dartz.dart';

import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/features/MemberSection/data/datasources/members/MemberLocalDataSources.dart';
import 'package:jci_app/features/MemberSection/data/datasources/members/MemberRemoteDataSources.dart';

import 'package:jci_app/core/Member.dart';

import '../../../../core/Handlers/Handler.dart';
import '../../../../core/PrimitiveUser/User.dart';
import '../../../../core/error/Exception.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/MemberModel.dart';
import '../../domain/repositories/MemberRepo.dart';
import '../datasources/members/AdminMemberOperations.dart';

class MemberRepoImpl extends MemberRepo {
  final MemberRemote memberRemote;
  final MemberLocalDatasoources membersLocalDataSource;
final Handler<Unit> handler;
final Handler<Member> memberHandler;
final Handler<List<Member>> membersListHandler;
final Handler<List<User>> UsersListHandler;


  MemberRepoImpl({required this.memberRemote, required this.membersLocalDataSource, required this.handler, required this.memberHandler, required this.membersListHandler, required this.UsersListHandler, });


  @override
  Future<Either<Failure, Member>> GetUserProfile(bool isUpdated) async{
return await memberHandler.handle(onCall: ()async{
    final members = await membersLocalDataSource.getUserProfile();
  if (isUpdated) {
    if (members == null) {
      final members = await memberRemote.getUserProfile();
      membersLocalDataSource.ChangeUserProfile(members);
      return members;
    }
    return members;
  }

  else{



    final members = await memberRemote.getUserProfile();
    membersLocalDataSource.ChangeUserProfile(members);

    return members;}

}, onError: (error){
  if (error is Exception) throw error;

}

);
  }

  @override
  Future<Either<Failure, Member>> getMemberByid(String id,bool status)async  {

return await memberHandler.handle(
    onCall: ()async {
      if ( status==true ||(await membersLocalDataSource.getMemberById(id)==null && status==false)){


      final members = await memberRemote.getMemberByid(id);
      await membersLocalDataSource.saveMemberByID(members,id);
      return members;

      }
      else {

      final members = await membersLocalDataSource.getMemberById(id);
      return members!;
      }
    },

    onError: (error){       if (error is Exception) throw error;

},
onFailConnection:  ()async{
    final members = await membersLocalDataSource.getMemberById(id);
    return members!;

}
);
  }

  @override
  Future<Either<Failure,Unit>> updateMember(Member member)async {
   final membermodel=MemberModel.fromEntity(member);

   return await handler.handle(

       onCall: ()=>    memberRemote.UpdateMemberProfile(membermodel),
       onError: (error) {
         if (error is Exception) throw error;
       });
  }
  @override
  Future<Either<Failure, List<Member>>> GetMemberByName(String name)async {
  return await membersListHandler.handle(onCall: ()=>memberRemote.GetmMemberByName(name),
      onError: (error){       if (error is Exception) throw error;
      });
  }
  @override
  Future<Either<Failure, List<User>>> GetMembers(bool isUpdated) async {
      final members = await membersLocalDataSource.GetMembers();
    return await UsersListHandler.handle(onCall: ()async{

      if (members.isEmpty  ||  isUpdated) {
        final members = await memberRemote.GetMembers();
        membersLocalDataSource.CacheMembers(members);
        return members;
      }
      return members;

    },
        onError: (error)async{    ;


    final members = await membersLocalDataSource.GetMembers();
    if (members.isEmpty){
    return ServerFailure();
    }
    return members;

        });
  }





  @override
  Future<Either<Failure, Unit>> ChangeLanguage(String language) async{
    return await handler.handle(

        onCall: ()=>    memberRemote.ChangeLanguage(language),
        onError: (error) {
          if (error is Exception) throw error;
        });
  }



  @override
  Future<Either<Failure, List<Member>>> GetMembersRank(bool isUpdated)async {
    return await membersListHandler.handle(onCall: ()async{
      final members = await membersLocalDataSource.GetMembersWithRanks
        ();
      if (members.isEmpty  ||  isUpdated) {
        final members = await memberRemote.getMembersWithRanks();
        membersLocalDataSource.CacheMemberwithRanks(members);
        return members;
      }
      return members;


    }, onError: (error)async{

      final members = await membersLocalDataSource.GetMembersWithRanks();
      if (members.isEmpty){
        return Left(ServerFailure());
      }
      return Right(members);

    });
  }

  @override
  Future<Either<Failure, Member>> GetMembeWithHighestRank(bool isUpdated)async  {
    return await memberHandler.handle(onCall: ()async{

      final members = await membersLocalDataSource.GetMemberWithRanks();
      ();
      if (members==null  ||  isUpdated) {
        final members = await memberRemote.getMemberWithHightRank();
        membersLocalDataSource.CacheMembewithRanks(members);
        return members;
      }
      return members;




    }, onError: (error)async{
    final members = await membersLocalDataSource.GetMemberWithRanks();
    if (members==null){
    return EmptyCacheFailure();
    }

    });

  }


  }


