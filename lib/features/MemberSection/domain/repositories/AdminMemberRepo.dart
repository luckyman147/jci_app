import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Failure.dart';

import '../../../../core/Member.dart';

abstract class AdminMemberRepo {
  Future<Either<Failure, Unit>> UpdatePoints(String memberid, double points);
  Future<Either<Failure, Unit>> UpdateCotisation(String memberid, int type, bool cotisation);
  Future<Either<Failure, Unit>> validateMember(String memberid);
  Future<Either<Failure, Unit>> deleteMember(String id);

}