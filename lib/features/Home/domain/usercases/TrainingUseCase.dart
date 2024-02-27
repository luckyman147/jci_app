import 'package:dartz/dartz.dart';
import 'package:jci_app/core/usescases/usecase.dart';

import '../../../../core/error/Failure.dart';

import '../entities/training.dart';
import '../repsotories/TrainingRepo.dart';


class GetALlTrainingsUseCase extends UseCase<List<Training>,NoParams> {
  @override
  Future<Either<Failure, List<Training>>> call(NoParams params)async  {
    return await TrainingRepository.getAllTrainings();
  }

  final TrainingRepo TrainingRepository;

  GetALlTrainingsUseCase({ required this.TrainingRepository});


}
class GetTrainingByIdUseCase {
  final TrainingRepo TrainingRepository;

  GetTrainingByIdUseCase({ required this.TrainingRepository});

  Future<Either<Failure,Training>> call(String id) async {
    return await TrainingRepository.getTrainingById(id);
  }
}
class GetTrainingsOfTheWeekUseCase extends UseCase<List<Training>,NoParams>{
  final TrainingRepo TrainingRepository;

  GetTrainingsOfTheWeekUseCase({required this.TrainingRepository});
  @override
  Future<Either<Failure,List<Training>>> call(NoParams params) async {
    return await TrainingRepository.getTrainingsOfTheWeek();
  }
}
class GetTrainingsOfTheMonthUseCase extends UseCase<List<Training>,NoParams>{
  final TrainingRepo TrainingRepository;

  GetTrainingsOfTheMonthUseCase({ required this.TrainingRepository});
  @override
  Future<Either<Failure,List<Training>>> call(NoParams params ) async {
    return await TrainingRepository.getTrainingsOfTheMonth();
  }
}
class CreateTrainingUseCase extends UseCase<Unit,Training> {
  final TrainingRepo TrainingRepository;

  CreateTrainingUseCase(this.TrainingRepository);

  Future<Either<Failure,Unit>> call(Training Training) async {
    return await TrainingRepository.createTraining(Training);
  }
}
class UpdateTrainingUseCase {
  final TrainingRepo TrainingRepository;

  UpdateTrainingUseCase(this.TrainingRepository);

  Future<Either<Failure,Training>> call(Training Training) async {
    return await TrainingRepository.updateTraining(Training);
  }
}
class DeleteTrainingUseCase {
  final TrainingRepo TrainingRepository;

  DeleteTrainingUseCase(this.TrainingRepository);

  Future<Either<Failure,Training>> call(String id) async {
    return await TrainingRepository.deleteTraining(id);
  }
}
class LeaveTrainingUseCase {
  final TrainingRepo TrainingRepository;

  LeaveTrainingUseCase(this.TrainingRepository);

  Future<Either<Failure,bool>> call(String id) async {
    return await TrainingRepository.leaveTraining(id);
  }
}

