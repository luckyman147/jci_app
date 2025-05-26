import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/features/MemberSection/data/datasources/members/AdminMemberOperations.dart';
import 'package:jci_app/features/MemberSection/domain/repositories/AdminMemberRepo.dart';

import '../../../../core/Handlers/Handler.dart';

class AdminRepoImpl implements AdminMemberRepo{
final AdminMemberOperations adminMemberOperations;
final Handler<Unit> handler;

  AdminRepoImpl(this.handler, {required this.adminMemberOperations});
  @override
  Future<Either<Failure, Unit>> UpdateCotisation(String memberid, int type, bool cotisation)async {
    return await handler.handle(

        onCall: ()=>   adminMemberOperations.validateCotisation(memberid, type, cotisation),
        onError: (error) {
          if (error is Exception) throw error;
        });
  }

  @override
  Future<Either<Failure, Unit>> UpdatePoints(String memberid, double points)async {


    return await handler.handle(

        onCall: ()=>   adminMemberOperations.UpdatePoints(memberid, points),
        onError: (error) {
          if (error is Exception) throw error;
        });
  }


@override
Future<Either<Failure, Unit>> deleteMember(String id) async{
  return await handler.handle(

      onCall: ()=>    adminMemberOperations.deleteMember(id),
      onError: (error) {
        if (error is Exception) throw error;
      });
}
@override
Future<Either<Failure, Unit>> validateMember(String memberid)async {
  return await handler.handle(

      onCall: ()=>    adminMemberOperations.validateMember(memberid),
      onError: (error) {
        if (error is Exception) throw error;
      });
}

}