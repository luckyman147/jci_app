import 'package:dartz/dartz.dart';

import '../../../../core/error/Failure.dart';
import '../entities/President.dart';

abstract class PresidentsRepo {
  Future<Either<Failure,List<President>>> getPresidents(String start,String limit);
  Future<Either<Failure,President> > CreatePresident(President president);
  Future<Either<Failure,Unit> > DeletePresident(String id);
  Future<Either<Failure,President> > UpdatePresident(President president);
  Future<Either<Failure,President> > UpdateImagePresident(President president);

}