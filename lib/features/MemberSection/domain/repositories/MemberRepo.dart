import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/memberBloc/member_management_bloc.dart';

import '../../../auth/domain/entities/Member.dart';
enum MemberType { admin, member,superAdmin }
abstract class MemberRepo {
  Future<Either<Failure,Member>> getMemberByid(String id,bool status );
  Future<Either<Failure,Unit> >UpdatePoints(String memberid,double points);
  Future<Either<Failure,Unit> >UpdateCotisation(String memberid,int type,bool cotisation);
  Future<Either<Failure,Unit> >validateMember(String memberid);
  Future<Either<Failure, Member>> GetUserProfile(bool Params);
  Future<Either<Failure, Unit>> ChangeToAdmin(String id, MemberType type);


  Future<Either<Failure, List<Member>>> GetMemberByName(String name);

  Future<Either<Failure, List<Member>>> GetMembers();

  Future<Either<Failure,Unit>> updateMember(Member member);
  Future<void> deleteMember(String id);
}