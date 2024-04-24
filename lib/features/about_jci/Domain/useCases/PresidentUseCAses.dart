import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/usescases/usecase.dart';
import 'package:jci_app/features/about_jci/Domain/Repository/PresidentsRepo.dart';
import 'package:jci_app/features/about_jci/Domain/entities/President.dart';

class CreatePresidentUseCases extends UseCase<President,President >{
  final PresidentsRepo repo;

  CreatePresidentUseCases({required this.repo});
  @override
  Future<Either<Failure, President>> call(President params) {
    return repo.CreatePresident(params);
  }
}
class DeletePresidentUseCases extends UseCase<Unit,String >{
  final PresidentsRepo repo;

  DeletePresidentUseCases({required this.repo});
  @override
  Future<Either<Failure, Unit>> call( params) {
    return repo.DeletePresident(params);
  }
}
class GetPresidentsUseCases {
  final PresidentsRepo repo;

  GetPresidentsUseCases({required this.repo});
  @override
  Future<Either<Failure, List<President>>> call({String start="0",String limit="6"}){
    return repo.getPresidents(start, limit);
  }
}
class UpdateImagePresidentUseCases extends UseCase<President,President >{
  final PresidentsRepo repo;

  UpdateImagePresidentUseCases({required this.repo});
  @override
  Future<Either<Failure, President>> call( President params) {
    return repo.UpdateImagePresident(params);
  }
}
class UpdatePresidentUseCases extends UseCase<President,President >{
  final PresidentsRepo repo;

  UpdatePresidentUseCases({required this.repo});
  @override
  Future<Either<Failure, President>> call(President params) {
    return repo.UpdatePresident(params);
  }
}