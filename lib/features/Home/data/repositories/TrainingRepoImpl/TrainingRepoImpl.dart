import 'package:dartz/dartz.dart';

import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/network/network_info.dart';
import 'package:jci_app/features/Home/data/model/TrainingModel/TrainingModel.dart';






import '../../../../../core/config/services/TrainingStore.dart';
import '../../../../../core/config/services/store.dart';
import '../../../../../core/config/services/verification.dart';
import '../../../../../core/error/Exception.dart';
import '../../../domain/entities/training.dart';
import '../../../domain/repsotories/TrainingRepo.dart';
import '../../datasources/trainings/TrainingLocalDatasources.dart';
import '../../datasources/trainings/Training_Remote_datasources.dart';

class TrainingRepoImpl implements TrainingRepo{
  final TrainingRemoteDataSource trainingRemoteDataSource;
  final TrainingLocalDataSource trainingLocalDataSource;
  final NetworkInfo networkInfo;

  TrainingRepoImpl({required this.trainingRemoteDataSource, required this.trainingLocalDataSource, required this.networkInfo});


  
  @override
  Future<Either<Failure, Unit>> createTraining(Training training) async{
    final trainingMode= TrainingModel.fromEntity(
    training
    );
    if (await networkInfo.isConnected) {
      try {
        await trainingRemoteDataSource.createTraining(trainingMode);
        return const Right(unit);
      } on WrongCredentialsException {
        return Left(WrongCredentialsFailure());
      }

      on ServerException {
        return Left(ServerFailure());
      }
      on EmptyDataException{
        return Left(EmptyDataFailure());
      }
    } else {
      return Left(OfflineFailure());
    }

  }

  @override
  Future<Either<Failure, Unit>> deleteTraining(String id)async  {
return await _getMessage(trainingRemoteDataSource.deleteTraining(id));
  }


  @override
  Future<Either<Failure, List<Training>>> getAllTrainings() async{

    if (await networkInfo.isConnected) {
      try {
        final remotetrainings = await trainingRemoteDataSource.getAllTraining();
        trainingLocalDataSource.cacheTrainings(remotetrainings);
        return Right(remotetrainings);
      } on EmptyDataException {
        return Left(EmptyDataFailure());
      }
    } else {
      try {
        final localtrainings = await trainingLocalDataSource
            .getAllCachedTrainings();
        return Right(localtrainings);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Training>> getTrainingById(String id)async {
    try {
      final training =await trainingRemoteDataSource.getTrainingById(id);
      return Right(training);
    } on EmptyDataException {
      return Left(EmptyDataFailure());
    }
  }

  @override
  Future<Either<Failure, Training>> getTrainingLikes(String id) {
    // TODO: implement getTrainingLikes
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Training>> getTrainingParticipants(String id) {
    // TODO: implement getTrainingParticipants
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Training>> getTrainingReports(String id) {
    // TODO: implement getTrainingReports
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Training>>> getTrainingsOfTheMonth()async  {
    if (await networkInfo.isConnected) {
      try {
        final remotetrainings = await trainingRemoteDataSource.getTrainingOfTheMonth();
        trainingLocalDataSource.cacheTrainingsOfTheMonth(remotetrainings);
        return Right(remotetrainings);
      } on EmptyDataException {
        return Left(EmptyDataFailure());
      }
    } else {
      try {
        final localtrainings = await trainingLocalDataSource.getCachedTrainingsOfTheMonth();
        return Right(localtrainings);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
  }}

  @override
  Future<Either<Failure, List<Training>>> getTrainingsOfTheWeek() async{
    if (await networkInfo.isConnected) {
      try {
        final remoteTrainings = await trainingRemoteDataSource.getTrainingOfTheWeek();
        trainingLocalDataSource.cacheTrainingsOfTheWeek(remoteTrainings);
        print("here is the remote Trainings $remoteTrainings");
        return Right(remoteTrainings);
      } on EmptyDataException {
        return Left(EmptyDataFailure());
      }
    } else {
      try {
        final localTrainings = await trainingLocalDataSource.getCachedTrainingsOfTheWeek();
        return Right(localTrainings);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> leaveTraining(String id)async {
    return await _getMessage(trainingRemoteDataSource.leaveTraining(id));
  }

  @override
  Future<Either<Failure, Unit>> participateTraining(String id)async  {
 return await  _getMessage(trainingRemoteDataSource.participateTraining(id));
  }

  @override
  Future<Either<Failure, Unit>> updateTraining(Training training)async  {
    final trainingMode= TrainingModel.fromEntity(training


    );
    return await _getMessage(trainingRemoteDataSource.updateTraining(trainingMode));

  }
  Future<Either<Failure, Unit>> _getMessage(
      Future<Unit> training) async {
    if (await networkInfo.isConnected) {
      try {
        await training;
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

  @override
  Future<Either<Failure, bool>> CheckPermissions() async {
    final eventPermission=await TrainingStore.getTrainPer();
    final userPermissions=await Store.getPermissions();
    if(eventPermission .isEmpty || userPermissions.isEmpty){
      return const Right(false);
    }
    else{

      return hasCommonElement(eventPermission, userPermissions)?const Right(true):const Right(false);
    }
  }
}