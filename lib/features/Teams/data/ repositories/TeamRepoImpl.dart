import 'package:dartz/dartz.dart';

import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/network/network_info.dart';
import 'package:jci_app/features/Teams/data/models/TeamModel.dart';
import 'package:jci_app/features/Teams/domain/entities/Team.dart';


import '../../../../../core/error/Exception.dart';
import '../../domain/repository/TeamRepo.dart';
import '../datasources/TeamLocalDataSources.dart';
import '../datasources/TeamRemoteDatasources.dart';

typedef Future<Unit> TeamAction();
class TeamRepoImpl implements TeamRepo{
  final TeamRemoteDataSource teamRemoteDataSource;
  final TeamLocalDataSource teamLocalDataSource;
  final NetworkInfo networkInfo;

  TeamRepoImpl({required this.teamRemoteDataSource, required this.teamLocalDataSource, required this.networkInfo});

  Future<Either<Failure, Unit>> _getMessage(
      Future<Unit> Team) async {
    if (await networkInfo.isConnected) {
      try {
        await Team;
        return const Right(unit);
      }

      on EmptyDataException {
        return Left(EmptyDataFailure());
      } on WrongCredentialsException {
        return Left(WrongCredentialsFailure());
      }
      on ServerException {
        return Left(ServerFailure());
      }
    }


    else {
      return Left(OfflineFailure());
    }
  }
  Future<Either<Failure, bool>> _getMessageBool(
      Future<bool> Team) async {
    if (await networkInfo.isConnected) {
      try {
        await Team;
        return Right(true);
      }

      on EmptyDataException {
        return Left(EmptyDataFailure());
      } on WrongCredentialsException {
        return Left(WrongCredentialsFailure());
      }
      on ServerException {
        return Left(ServerFailure());
      }
    }


    else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addTeam(Team team) async{

final teamMosdel=TeamModel.fromEntity(team,true);
    return   _getMessage( teamRemoteDataSource.createTeam(teamMosdel));
  }

  @override
  Future<Either<Failure, Unit>> deleteTeam(String id) {
    // TODO: implement deleteTeam
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Team>> getTeamById(String id)async  {

      try {
        final remoteTeams = await teamRemoteDataSource.getTeamById(id);

        return Right(remoteTeams);
      } on ServerException {
        return Left(ServerFailure());
      }


  }

  @override
  Future<Either<Failure, List<Team>>> getTeams() async {

    if (await networkInfo.isConnected) {
      try {
        final remoteTeams = await teamRemoteDataSource.getAllTeams();
        teamLocalDataSource.cacheTeams(remoteTeams);
        return Right(remoteTeams);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTeams = await teamLocalDataSource.getAllCachedTeams();
        return Right(localTeams);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> updateImage(String id, String path) {
    // TODO: implement updateImage
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> updateTeam(Team team) {
    // TODO: implement updateTeam
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> uploadTeamImage(String id, String path) {
    // TODO: implement uploadTeamImage
    throw UnimplementedError();
  }

}