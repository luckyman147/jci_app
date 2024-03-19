import 'package:dartz/dartz.dart';
import 'package:jci_app/features/Teams/domain/entities/Checklist.dart';

import '../../../../core/error/Failure.dart';
import '../entities/Team.dart';

abstract class TeamRepo{

  Future<Either<Failure,List<Team>>> getTeams(String page,String limit);
  Future<Either<Failure,Team>> getTeamById(String id );
  Future<Either<Failure,Unit>> addTeam(Team team);
  Future<Either<Failure,Unit>> updateTeam(Team team);
  Future<Either<Failure,Unit>> deleteTeam(String id);
  Future<Either<Failure,Unit>> updateImage(String id, String path);
  Future<Either<Failure,Unit>> uploadTeamImage(String id, String path);


}