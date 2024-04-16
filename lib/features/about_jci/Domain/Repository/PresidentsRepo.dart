import 'package:dartz/dartz.dart';

import '../../../../core/error/Failure.dart';
import '../entities/President.dart';

abstract class PresidentsRepo {
  Future<Either<Failure,List<President>>> getPresidents();
  Future<Either<Failure,Unit> > CreatePresident(President president);
  Future<Either<Failure,Unit> > DeletePresident(String id);
  Future<Either<Failure,Unit> > UpdatePresident(President president);
  Future<Either<Failure,Unit> > UpdateImagePresident(President president);

}