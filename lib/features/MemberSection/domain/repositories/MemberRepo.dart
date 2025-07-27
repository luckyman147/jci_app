import 'package:dartz/dartz.dart';
import 'package:jci_app/core/PrimitiveUser/User.dart';
import 'package:jci_app/core/error/Failure.dart';

import '../../../../core/Member.dart';
enum MemberType { admin, member,superAdmin }
abstract class MemberRepo {
  Future<Either<Failure,Member>> getMemberByid(String id,bool status );
  Future<Either<Failure,Unit> >ChangeLanguage(String language);
  Future<Either<Failure, Member>> GetUserProfile(bool Params);
  Future<Either<Failure, List<User>>> GetMemberByName(String name);
  Future<Either<Failure, List<Member>>> GetMembersRank(bool isUpdated, );
  Future<Either<Failure, Member>> GetMembeWithHighestRank(bool isUpdated, );
  Future<Either<Failure, List<User>>> GetMembers(bool isUpdated);
  Future<Either<Failure,Unit>> updateMember(Member member);

}