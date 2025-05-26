import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/usescases/usecase.dart';
import 'package:jci_app/features/MemberSection/domain/entity/Objectif.dart';
import 'package:jci_app/features/MemberSection/domain/repositories/objectifsRepo.dart';

import '../dto/ObjectifPagination.dart';
import '../dto/UpdateObjectiveProgressDTO.dart';
import '../entity/UserObjectifInfos.dart';

/// update Objective progress Uses Case
/// take [updateUserObjectivesProgress] as input
/// return [List<UserObjectiveInfos>] as output
class updateUserObjectivesProgressUsesCase extends UseCase<List<UserObjectifInfos>,UpdateObjectiveProgressDTO>{
  final ObjectifRepo objectifRepo;

  updateUserObjectivesProgressUsesCase({required this.objectifRepo});

  @override
  Future<Either<Failure, List<UserObjectifInfos>>> call(UpdateObjectiveProgressDTO params) async{
return await objectifRepo.updateUserObjectivesProgress(params);
  }

}


class AddObjectifUsesCase extends UseCase<Unit,Objectif>{
  final ObjectifRepo objectifRepo;

  AddObjectifUsesCase({required this.objectifRepo});
  @override
  Future<Either<Failure, Unit>> call(Objectif params)async {
    return await objectifRepo.AddObjectif(params);
  }
}

class UpdateObjectifUsesCase extends UseCase<Unit,Objectif>{
  final ObjectifRepo objectifRepo;

  UpdateObjectifUsesCase({required this.objectifRepo});
  @override
  Future<Either<Failure, Unit>> call(Objectif params)async {
    return await objectifRepo.UpdateObjectif(params);
  }
}
class DeleteObjectifUsesCase extends UseCase<Unit,String>{
  final ObjectifRepo objectifRepo;

  DeleteObjectifUsesCase({required this.objectifRepo});
  @override
  Future<Either<Failure, Unit>> call(String params)async {
    return await objectifRepo.DeleteObjectif(params);
  }
}
class fetchUserWithHisObjectifsProgressUsesCase extends UseCase<({List<UserObjectifInfos> userObjectifInfos, DocumentSnapshot? lastDoc}),ObjectifPaginationDto>{
  final ObjectifRepo objectifRepo;

  fetchUserWithHisObjectifsProgressUsesCase({required this.objectifRepo});
  @override
  Future<Either<Failure,({List<UserObjectifInfos> userObjectifInfos, DocumentSnapshot? lastDoc})>> call(ObjectifPaginationDto params)async {
    return  objectifRepo.fetchUserWithHisObjectifsProgress(
      userId: params.userId,
      lastDocument: params.lastDocument,
      limit: params.limit
    );
  }
}