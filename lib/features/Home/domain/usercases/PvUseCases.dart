import 'package:dartz/dartz.dart';
import 'package:jci_app/features/Home/domain/Dtos/PVParamDto.dart';
import 'package:jci_app/features/Home/domain/repsotories/PVRepo.dart';

import '../../../../core/error/Failure.dart';
import '../../../../core/usescases/usecase.dart';
import '../entities/PVEntity/PV.dart';

class GetPvsOfActivty extends UseCase<List<PV>, String> {
  final PVrepo repository;

  GetPvsOfActivty(this.repository);

  @override
  Future<Either<Failure, List<PV>>> call(String params) async {
    return await repository.GetPVs(params);

  }

}
class AddPv extends UseCase<Unit, PvParamDto> {
  final PVrepo repository;

  AddPv(this.repository);

  @override
  Future<Either<Failure, Unit>> call(PvParamDto params) async {
    return await repository.AddPV(params.pvParam, params.ActivityId);

  }


}
class DeletePv extends UseCase<Unit, PvParamDto> {
  final PVrepo repository;

  DeletePv(this.repository);

  @override
  Future<Either<Failure, Unit>> call( params) async {
    return await repository.DeletePV(params.PVId!, params.ActivityId);

  }

}class DownloadPv extends UseCase<Unit, PV> {
  final PVrepo repository;

  DownloadPv(this.repository);

  @override
  Future<Either<Failure, Unit>> call( params) async {
    return await repository.downloadFile(params);

  }

}