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
  Future<Either<Failure, President>> CreatePresident(President president) async{
    await localPresidentsDataSources.CacheUpdated(true);

    return await _getMessagePresident(remotePresidentsDataSources.CreatePresident(PresidentModel.fromEntity(president)));
  }

  @override
  Future<Either<Failure, Unit>> DeletePresident(String id) async{
    await localPresidentsDataSources.CacheUpdated(true);

    return await _getMessage(remotePresidentsDataSources.DeletePresident(id));

  }

  @override
  Future<Either<Failure, President>> UpdateImagePresident(President president) async{
    final presidentmodel= PresidentModel.fromEntity(president);
    await localPresidentsDataSources.CacheUpdated(true);
    return await _getMessagePresident(remotePresidentsDataSources.UpdateImagePresident(presidentmodel));

  }

  @override
  Future<Either<Failure, President>> UpdatePresident(President president)async  {
    final presidentmodel= PresidentModel.fromEntity(president);
    await localPresidentsDataSources.CacheUpdated(true);

    return await _getMessagePresident(remotePresidentsDataSources.UpdatePresident(presidentmodel));

  }

  @override
  Future<Either<Failure, List<President>>> getPresidents(String start,String limit) async{
    if (await networkInfo.isConnected) {

      try {

        final remoteTeams = await remotePresidentsDataSources.getPresidents(start,limit);
        localPresidentsDataSources.CachePresidents(remoteTeams, start, limit);
        return Right(remoteTeams);

      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTeams = await localPresidentsDataSources.getPresidents(start,limit);
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
}
  Future<Either<Failure, President>> _getMessagePresident(
      Future<PresidentModel> presidents) async {
    if (await networkInfo.isConnected) {
      try {
    final pre=    await presidents;
        return  Right(pre);
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
}

}
