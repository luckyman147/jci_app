import 'package:dartz/dartz.dart';
import 'package:jci_app/features/Teams/domain/repository/TeamRepo.dart';

import '../../../../core/error/Failure.dart';
import '../../../../core/usescases/usecase.dart';
import '../../../auth/domain/entities/Member.dart';
import '../entities/Team.dart';

class GetAllTeamsUseCase {
  final TeamRepo _teamRepository;

  GetAllTeamsUseCase(this._teamRepository);



  Future<Either<Failure, List<Team>>> call({String page="0",String limit="5",isPrivate=false,updated=true}) async {
    return await _teamRepository.getTeams(page, limit, isPrivate, updated);
  }
}
class GetTeamByIdUseCase  extends UseCase<Team, Map<String,dynamic>>{
  final TeamRepo _teamRepository;

  GetTeamByIdUseCase(this._teamRepository);


  @override
  Future<Either<Failure, Team>> call( Map<String,dynamic> params) async {
    return await _teamRepository.getTeamById(params['id']!,params['isUpdated']!);
  }
}
class AddTeamUseCase  extends UseCase<Team, Team>{
  final TeamRepo _teamRepository;

  AddTeamUseCase(this._teamRepository);


  @override
  Future<Either<Failure, Team>> call(Team team) async {
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
class getTeamByNameUseCase  extends UseCase<List<Team>, Map<String,dynamic>>{
  final TeamRepo _teamRepository;

  getTeamByNameUseCase(this._teamRepository);

  @override
  Future<Either<Failure, List<Team>>> call(Map<String,dynamic> params) {
    return _teamRepository.getTeamByName(params['name']);
  }
}
class UpdateTeamMembersUseCase  extends UseCase<Unit, TeamInput>{
  final TeamRepo _teamRepository;

  UpdateTeamMembersUseCase(this._teamRepository);

  @override
  Future<Either<Failure, Unit>> call( params) {
    return _teamRepository.UpdateMembers(params.id,params.memberid!,params.Status!);
  }
}
class InviteMemberUseCase  extends UseCase<Unit, TeamInput>{
  final TeamRepo _teamRepository;

  InviteMemberUseCase(this._teamRepository);

  @override
  Future<Either<Failure, Unit>> call( params) {
    return _teamRepository.InviteMember(params.id,params.memberid!);
  }
}
class TeamInput{
  final String id;
  final String? memberid;
  final String? Status;
  final Map<String,dynamic>? member;


  TeamInput(this.id, this.memberid, this.Status, this.member);
}

