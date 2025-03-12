import 'package:dartz/dartz.dart';
import 'package:jci_app/features/Home/domain/entities/PVEntity/PV.dart';

import '../../../../core/error/Failure.dart';

abstract class PVrepo{
  Future<Either<Failure,List<PV>>> GetPVs(String activityId);
  // TODO: Add Pv
  Future<Either<Failure,Unit>> AddPV(PV pv, String activityId);
  //delete PV
  Future<Either<Failure,Unit>> DeletePV(String pvId, String activityId);
Future<Either<Failure,Unit>> downloadFile(PV pv);
}