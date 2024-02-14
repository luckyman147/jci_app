
import 'package:dartz/dartz.dart';
import 'package:jci_app/features/auth/domain/entities/LoginMember.dart';
import '../../../../core/error/Failure.dart';
import '../entities/Member.dart';

abstract class AuthRepo {



  Future<Either<Failure, bool>> signOut();

  Future<Either<Failure, MemberSignUp>> sendPasswordResetEmail(String email);
  Future<Either<Failure, MemberSignUp>> verifyEmail();
  Future<Either<Failure, Unit>> updatePassword(Member member);
  Future<Either<Failure,bool>> refreshToken();

  Future<Either<Failure, MemberSignUp>> deleteAccount();
}