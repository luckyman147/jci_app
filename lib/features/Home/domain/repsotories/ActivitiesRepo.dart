import 'package:dartz/dartz.dart';

import '../../../../core/error/Failure.dart';
import '../../domain/entities/Activity.dart';
import '../../presentation/bloc/Activity/activity_cubit.dart';

abstract class ActivitiesRepo{
  Future<Either<Failure, List<Activity>>> getAllActvities(activity act);
  Future<Either<Failure, Activity>> getActivityById(String id,activity act);

  Future<Either<Failure, Unit>> createEvent(Activity event,activity act);
  Future<Either<Failure, Unit>> updateEvent(Activity event, activity type);
  Future<Either<Failure, Unit>> deleteEvent(String id,activity act);
  Future<Either<Failure, Unit>> leaveEvent(String id,activity act);
  Future<Either<Failure, Unit>> participateEvent(String id,activity act);


  Future<Either<Failure, bool>> CheckPermissions(activity act);

}