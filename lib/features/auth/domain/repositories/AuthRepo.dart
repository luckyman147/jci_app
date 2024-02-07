
import 'package:dartz/dartz.dart';
import '../../../../core/error/Failure.dart';
import '../entities/Member.dart';

abstract class AuthRepo {



  Future<Either<Failure, MemberSignUp>> signOut();

  Future<Either<Failure, MemberSignUp>> sendPasswordResetEmail(String email);
  Future<Either<Failure, MemberSignUp>> verifyEmail();
  Future<Either<Failure, MemberSignUp>> updatePassword(String password);


  Future<Either<Failure, MemberSignUp>> deleteAccount();
}