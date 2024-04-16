import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/usescases/usecase.dart';
import 'package:jci_app/features/Home/domain/entities/Activity.dart';
import 'package:jci_app/features/Home/domain/repsotories/ActivitiesRepo.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';

class GetAllActivitiesUseCases extends UseCase<List<Activity>,activity >{
  final ActivitiesRepo activitiesRepo;

  GetAllActivitiesUseCases({required this.activitiesRepo});
  @override
  Future<Either<Failure, List<Activity>>> call(activity params) {
    return activitiesRepo.getAllActvities(params);

  }
}
class GetActivityByIdUseCases extends UseCase<Activity,activityParams >{
  final ActivitiesRepo activitiesRepo;

  GetActivityByIdUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, Activity>> call(activityParams params) {
    return activitiesRepo.getActivityById(params.id!, params.type);
  }
}

class CreateActivityUseCases extends UseCase<Unit,activityParams >{
  final ActivitiesRepo activitiesRepo;

  CreateActivityUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, Unit>> call(activityParams params) {
    return activitiesRepo.createEvent(params.act!, params.type);
  }


}

class UpdateActivityUseCases extends UseCase<Unit,activityParams > {
  final ActivitiesRepo activitiesRepo;

  UpdateActivityUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, Unit>> call(activityParams params) {
    return activitiesRepo.updateEvent(params.act!, params.type);
  }
}
class DeleteActivityUseCases extends UseCase<Unit,activityParams > {
  final ActivitiesRepo activitiesRepo;

  DeleteActivityUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, Unit>> call(activityParams params) {
    return activitiesRepo.deleteEvent(params.id!, params.type);
  }
}
class LeaveActivityUseCases extends UseCase<Unit,activityParams > {
  final ActivitiesRepo activitiesRepo;

  LeaveActivityUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, Unit>> call(activityParams params) {
    return activitiesRepo.leaveEvent(params.id!, params.type);
  }
}
class ParticipateActivityUseCases extends UseCase<Unit,activityParams > {
  final ActivitiesRepo activitiesRepo;

  ParticipateActivityUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, Unit>> call(activityParams params) {
    return activitiesRepo.participateEvent(params.id!, params.type);
  }
}




class activityParams {
  final Activity? act;
  final activity type;
final String? id;
  activityParams( {required this.act, required this.type,required this.id,});
}