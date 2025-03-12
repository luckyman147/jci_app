import 'package:dartz/dartz.dart';
import 'package:jci_app/core/usescases/usecase.dart';
import 'package:jci_app/features/Home/domain/Dtos/ActivityParam.dart';
import 'package:jci_app/features/Home/domain/entities/Activity.dart';
import 'package:jci_app/features/Home/domain/repsotories/ActivitiesRepo.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';

import '../../../auth/AuthWidgetGlobal.dart';


class GetAllActivitiesUseCases extends UseCase<List<Activity>,activity >{
  final ActivitiesRepo activitiesRepo;

  GetAllActivitiesUseCases({required this.activitiesRepo});
  @override
  Future<Either<Failure, List<Activity>>> call(activity params) {
    return activitiesRepo.getAllActivities(params);

  }
}

class GetActivityByIdUseCases extends UseCase<Activity,activityParams >{
  final ActivitiesRepo activitiesRepo;

  GetActivityByIdUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, Activity>> call(activityParams params) {
    return activitiesRepo.getActivityById(params.Eventid!, params.type);
  }
}class GetActivityByNameUseCases extends UseCase<List<Activity>,activityParams >{
  final ActivitiesRepo activitiesRepo;

  GetActivityByNameUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, List<Activity>>> call(activityParams params) {
    return activitiesRepo.getActivityByName(params.name!, params.type);
  }
}

class CreateActivityUseCases extends UseCase<Unit,activityParams >{
  final ActivitiesRepo activitiesRepo;

  CreateActivityUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, Unit>> call(activityParams params) {
    return activitiesRepo.createActivity(params.act!, params.type);
  }


}

class UpdateActivityUseCases extends UseCase<Unit,activityParams > {
  final ActivitiesRepo activitiesRepo;

  UpdateActivityUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, Unit>> call(activityParams params) {
    return activitiesRepo.updateActivity(params.act!, params.type);
  }
}
class DeleteActivityUseCases extends UseCase<Unit,activityParams > {
  final ActivitiesRepo activitiesRepo;

  DeleteActivityUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, Unit>> call(activityParams params) {
    return activitiesRepo.deleteActivity(params.Eventid!, params.type);
  }
}
class LeaveActivityUseCases extends UseCase<Unit,activityParams > {
  final ActivitiesRepo activitiesRepo;

  LeaveActivityUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, Unit>> call(activityParams params) {
    return activitiesRepo.leaveActivity(params.Eventid!, params.type);
  }
}
class ParticipateActivityUseCases extends UseCase<Unit,activityParams > {
  final ActivitiesRepo activitiesRepo;

  ParticipateActivityUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, Unit>> call(activityParams params) {
    Logger().i("participateActivity",params.Eventid);
    return activitiesRepo.participateActivity(params.Eventid!, params.type);
  }
}
class CheckPermissionsUseCases extends UseCase<bool,activity > {
  final ActivitiesRepo activitiesRepo;

  CheckPermissionsUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, bool>> call(activity params) {
    return activitiesRepo.checkPermissions(params);
  }
}





