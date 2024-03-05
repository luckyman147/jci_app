
import 'package:dartz/dartz.dart';
import 'package:jci_app/features/auth/domain/entities/Member.dart';
import '../../../../core/error/Failure.dart';


abstract class AuthRepo {



  Future<Either<Failure, bool>> signOut();
  Future<Either<Failure, Unit>> GetUserProfile();
  Future<Either<Failure, List<Member>>> GetAllMembers();
  Future<Either<Failure, List<Member>>> GetMemberByName(String name);
  Future<Either<Failure, Member>> sendPasswordResetEmail(String email);
  Future<Either<Failure, Member>> verifyEmail();
  Future<Either<Failure, Unit>> updatePassword(Member member);

  Future<Either<Failure,bool>> refreshToken();

  Future<Either<Failure, Member>> deleteAccount();
}