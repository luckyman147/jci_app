import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/features/about_jci/Domain/Repository/PresidentsRepo.dart';
import 'package:jci_app/features/about_jci/Domain/entities/President.dart';

import '../../../../core/error/Exception.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/LocalPresidentsDataSources.dart';
import '../datasources/RemotePresidentsDataSources.dart';
import '../models/PresidentModel.dart';

class PresidentRepoImpl implements PresidentsRepo  {
  final LocalPresidentsDataSources localPresidentsDataSources;
  final RemotePresidentsDataSources remotePresidentsDataSources;
  final NetworkInfo networkInfo;

  PresidentRepoImpl({required this.localPresidentsDataSources, required this.remotePresidentsDataSources, required this.networkInfo});
  @override
  Future<Either<Failure, Unit>> CreatePresident(President president) async{
    return await _getMessage(remotePresidentsDataSources.CreatePresident(PresidentModel.fromEntity(president)));
  }

  @override
  Future<Either<Failure, Unit>> DeletePresident(String id) async{
    return await _getMessage(remotePresidentsDataSources.DeletePresident(id));

  }

  @override
  Future<Either<Failure, Unit>> UpdateImagePresident(President president) async{
    final presidentmodel= PresidentModel.fromEntity(president);
    return await _getMessage(remotePresidentsDataSources.UpdateImagePresident(presidentmodel));

  }

  @override
  Future<Either<Failure, Unit>> UpdatePresident(President president)async  {
    final presidentmodel= PresidentModel.fromEntity(president);
    return await _getMessage(remotePresidentsDataSources.UpdatePresident(presidentmodel));

  }

  @override
  Future<Either<Failure, List<President>>> getPresidents() async{
    if (await networkInfo.isConnected) {

      try {

        final remoteTeams = await remotePresidentsDataSources.getPresidents();
        localPresidentsDataSources.CachePresidents(remoteTeams);
        return Right(remoteTeams);

      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTeams = await remotePresidentsDataSources.getPresidents();
        return Right(localTeams);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  Future<Either<Failure, Unit>> _getMessage(
      Future<Unit> presidents) async {
    if (await networkInfo.isConnected) {
      try {
        await presidents;
        return const Right(unit);
      }

      on EmptyDataException {
        return Left(EmptyDataFailure());
      } on WrongCredentialsException {
        return Left(WrongCredentialsFailure());
      }
      on UnauthorizedException {

        return Left(UnauthorizedFailure());
      }
      on ServerException {
        return Left(ServerFailure());
      }
    }


    else {
      return Left(OfflineFailure());
    }
}}
