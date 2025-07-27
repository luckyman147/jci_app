import 'package:dartz/dartz.dart';


import '../../../../core/error/Failure.dart';
import '../entities/Activitys/Activity.dart';
import '../../presentation/bloc/Activity/activity_cubit.dart';


abstract class ActivitiesRepo{
  Future<Either<Failure, List<Activity>>> getAllActivities(activity act);
  Future<Either<Failure, List<Activity>>> getActivityByName(String name, activity act);
  Future<Either<Failure, Activity>> getActivityById(String id, activity act);

  Future<Either<Failure, Unit>> createActivity(Activity Activity, activity act);
  Future<Either<Failure, Unit>> updateActivity(Activity Activity, activity act);
  Future<Either<Failure, Unit>> deleteActivity(String id, activity act);

  Future<Either<Failure, Unit>> leaveActivity(String id, activity act);
  Future<Either<Failure, Unit>> participateActivity(String id, activity act);

  Future<Either<Failure, bool>> checkPermissions(activity act);
}

