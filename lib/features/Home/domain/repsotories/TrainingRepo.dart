import 'package:dartz/dartz.dart';

import '../../../../core/error/Failure.dart';
import '../entities/training.dart';

abstract class TrainingRepo {
  Future<Either<Failure, List<Training>>> getAllTrainings();

  Future<Either<Failure, Training>> getTrainingById(String id);

  Future<Either<Failure, List<Training>>> getTrainingsOfTheWeek();

  Future<Either<Failure, List<Training>>> getTrainingsOfTheMonth();

  Future<Either<Failure, Unit>> createTraining(Training Training);

  Future<Either<Failure, Training>> updateTraining(Training Training);

  Future<Either<Failure, Training>> deleteTraining(String id);

  Future<Either<Failure, bool>> leaveTraining(String id);

  Future<Either<Failure, bool>> participateTraining(String id);

  Future<Either<Failure, Training>> getTrainingLikes(String id);

  Future<Either<Failure, Training>> getTrainingParticipants(String id);

  Future<Either<Failure, Training>> getTrainingReports(String id);
}