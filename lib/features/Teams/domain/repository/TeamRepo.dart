import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/PrimitiveUser/User.dart';
import '../../../../core/error/Failure.dart';
import '../entities/Team/Team.dart';
import '../entities/TeamUser.dart';

abstract class TeamRepo{

  Future<Either<Failure,({List<Team> Teams, DocumentSnapshot? lastDoc})>> getTeams(int limit,bool isPrivate,DocumentSnapshot? doc);
  Future<Either<Failure,List<Team>>> getTeamByName(String name);
  Future<Either<Failure,List<Team>>>  getTeamsOfUser();

  Future<Either<Failure,Team>> getTeamById(String id,bool isUpdated );
  Future<Either<Failure,Team>> addTeam(Team team);
  Future<Either<Failure,Unit>> updateTeam(Team team);
  Future<Either<Failure,Unit>> deleteTeam(String id);
  Future<Either<Failure,Unit>> updateImage(String id, String path);
  Future<Either<Failure,Unit>> uploadTeamImage(String id, String path);
  Future<Either<Failure,Unit>> InviteMember(String id, String memberid);
  Future<Either<Failure,Unit>> JoinTeam(TeamUser user,String TeamId );
  Future<Either<Failure,Unit>> kickMember(String id, String memberid);
  Future<Either<Failure,Unit>> UpdateMembersRole(String teamid, String memberid, String newRole);


}