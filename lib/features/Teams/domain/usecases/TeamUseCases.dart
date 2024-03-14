import 'package:dartz/dartz.dart';
import 'package:jci_app/features/Teams/domain/repository/TeamRepo.dart';

import '../../../../core/error/Failure.dart';
import '../../../../core/usescases/usecase.dart';
import '../entities/Team.dart';

class GetAllTeamsUseCase  extends UseCase<List<Team>, NoParams>{
  final TeamRepo _teamRepository;

  GetAllTeamsUseCase(this._teamRepository);


  @override
  Future<Either<Failure, List<Team>>> call(NoParams params) async {
    return await _teamRepository.getTeams();
  }
}
class GetTeamByIdUseCase  extends UseCase<Team, String>{
  final TeamRepo _teamRepository;

  GetTeamByIdUseCase(this._teamRepository);


  @override
  Future<Either<Failure, Team>> call(String id) async {
    return await _teamRepository.getTeamById(id);
  }
}
class AddTeamUseCase  extends UseCase<Unit, Team>{
  final TeamRepo _teamRepository;

  AddTeamUseCase(this._teamRepository);


  @override
  Future<Either<Failure, Unit>> call(Team team) async {
    return await _teamRepository.addTeam(team);
  }
}
class UpdateTeamUseCase  extends UseCase<Unit, Team>{
  final TeamRepo _teamRepository;

  UpdateTeamUseCase(this._teamRepository);


  @override
  Future<Either<Failure, Unit>> call(Team team) async {
    return await _teamRepository.updateTeam(team);
  }
}
class DeleteTeamUseCase  extends UseCase<Unit, String>{
  final TeamRepo _teamRepository;

  DeleteTeamUseCase(this._teamRepository);


  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return await _teamRepository.deleteTeam(id);
  }
}
