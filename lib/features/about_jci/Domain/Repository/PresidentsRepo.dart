import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/Failure.dart';
import '../entities/President.dart';

abstract class PresidentsRepo {
  @override
  Future<Either<Failure, (List<President>, DocumentSnapshot?)>> getPresidents(    int limit, {
    DocumentSnapshot? lastDocument,
  }) ;  Future<Either<Failure,President> > CreatePresident(President president);
  Future<Either<Failure,Unit> > DeletePresident(String id);
  Future<Either<Failure,President> > UpdatePresident(President president);
  Future<Either<Failure,President> > UpdateImagePresident(President president);

}