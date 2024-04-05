import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Failure.dart';

import '../../../auth/domain/entities/Member.dart';

abstract class MemberRepo {
  Future<Either<Failure,Member>> getMember(String id);
  Future<Either<Failure,Unit> >UpdatePoints(String memberid,double points);
  Future<Either<Failure,Unit> >UpdateCotisation(String memberid,List<bool> cotisation);
  Future<Either<Failure, Member>> GetUserProfile(bool Params);
  Future<Either<Failure, List<Member>>> GetMemberByName(String name);

  Future<Either<Failure, List<Member>>> GetMembers();

  Future<Either<Failure,Unit>> updateMember(Member member);
  Future<void> deleteMember(String id);
}