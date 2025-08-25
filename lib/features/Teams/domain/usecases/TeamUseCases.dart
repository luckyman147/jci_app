import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:jci_app/features/Teams/domain/repository/TeamRepo.dart';

import '../../../../core/PrimitiveUser/User.dart';
import '../../../../core/error/Failure.dart';
import '../../../../core/usescases/usecase.dart';
import '../entities/Team/Team.dart';
import '../entities/TeamUser.dart';

class GetAllTeamsUseCase {
  final TeamRepo _teamRepository;

  GetAllTeamsUseCase(this._teamRepository);



  Future<Either<Failure, ({List<Team> Teams, DocumentSnapshot? lastDoc})>> call({int limit=3,isPrivate=false,DocumentSnapshot? doc}) async {
    return await _teamRepository.getTeams( limit, isPrivate, doc);
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
}class  GetTeamsOfUserUseCase  extends UseCase<List<Team>, NoParams>{
  final TeamRepo _teamRepository;

  GetTeamsOfUserUseCase(this._teamRepository);

  @override
  Future<Either<Failure, List<Team>>> call( params) {
    return _teamRepository.getTeamsOfUser();
  }
}
class UpdateTeamMembersRoleUseCase  extends UseCase<Unit, TeamInput>{
  final TeamRepo _teamRepository;

  UpdateTeamMembersRoleUseCase(this._teamRepository);

  @override
  Future<Either<Failure, Unit>> call( params) {
    return _teamRepository.UpdateMembersRole(params.id,params.memberid!,params.newRole!.name);
  }
}
class RemoveMemberUseCase  extends UseCase<Unit, TeamInput>{
  final TeamRepo _teamRepository;

  RemoveMemberUseCase(this._teamRepository);

  @override
  Future<Either<Failure, Unit>> call( params) {
    return _teamRepository.kickMember(params.id,params.memberid!);
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
class JoinTeamUseCase  extends UseCase<Unit, TeamInput>{
  final TeamRepo _teamRepository;

  JoinTeamUseCase(this._teamRepository);

  @override
  Future<Either<Failure, Unit>> call( params) {
    return _teamRepository.JoinTeam(params.member!, params.id);
  }
}
class TeamInput{
  final String id;
  final String? memberid;
  final UserTeamRole? newRole;
  final TeamUser? member;
  final String? Status;


  TeamInput(this.id,this.memberid,this.Status,  this.newRole, this.member);
}

