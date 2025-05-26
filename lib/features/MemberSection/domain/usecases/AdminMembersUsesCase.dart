
import 'package:dartz/dartz.dart';
import 'package:jci_app/features/MemberSection/domain/repositories/AdminMemberRepo.dart';

import '../../../../core/error/Failure.dart';
import '../../../../core/usescases/usecase.dart';

class DeleteMemberUseCase extends UseCase<Unit, String>{
  final AdminMemberRepo adminMemberRepo;

  DeleteMemberUseCase({required this.adminMemberRepo});

  @override
  Future<Either<Failure, Unit>> call(String params) async {
    return await adminMemberRepo.deleteMember(params);
  }

}class UpdateCotisationUseCase extends UseCase<Unit, UpdateCotisationParams>{
  final AdminMemberRepo adminMemberRepo;

  UpdateCotisationUseCase({required this.adminMemberRepo});

  @override
  Future<Either<Failure, Unit>> call(UpdateCotisationParams params) async {
    return await adminMemberRepo.UpdateCotisation(params.memberid,params.type, params.cotisation);
  }

}class validateMemberuseCase extends UseCase<Unit, String>{
  final AdminMemberRepo adminMemberRepo;

  validateMemberuseCase({required this.adminMemberRepo});

  @override
  Future<Either<Failure, Unit>> call(String params) async {
    return await adminMemberRepo.validateMember(params);
  }

}class UpdatePointsUseCase extends UseCase<Unit, UpdatePointsParams>{
  final AdminMemberRepo adminMemberRepo;

  UpdatePointsUseCase({required this.adminMemberRepo});

  @override
  Future<Either<Failure, Unit>> call(UpdatePointsParams params) async {
    return await adminMemberRepo.UpdatePoints(params.memberid, params.points);
  }

}
class UpdatePointsParams {
  final String memberid;
  final double points;


  UpdatePointsParams({required this.memberid, required this.points});
}class UpdateCotisationParams {
  final String memberid;
  final bool cotisation;
  final int type;

  UpdateCotisationParams({required this.memberid, required this.cotisation, required this.type});
}