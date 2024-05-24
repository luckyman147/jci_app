import 'package:dartz/dartz.dart';
import 'package:jci_app/features/Home/domain/entities/ActivityGuest.dart';
import 'package:jci_app/features/Home/domain/entities/ActivityParticpants.dart';

import '../../../../core/error/Failure.dart';
import '../../domain/entities/Activity.dart';
import '../../presentation/bloc/Activity/activity_cubit.dart';
import '../entities/Guest.dart';

abstract class ActivitiesRepo{
  Future<Either<Failure, List<Activity>>> getAllActvities(activity act);
  Future<Either<Failure, List<Activity>>> getActivityByname(String name,activity act);
  Future<Either<Failure, Activity>> getActivityById(String id,activity act);

  Future<Either<Failure, Unit>> createEvent(Activity event,activity act);
  Future<Either<Failure, Unit>> updateEvent(Activity event, activity type);
  Future<Either<Failure, Unit>> deleteEvent(String id,activity act);
  Future<Either<Failure, Unit>> leaveEvent(String id,activity act);
  Future<Either<Failure, Unit>> participateEvent(String id,activity act);
Future<Either<Failure,Unit>> CheckAbsence(String activityId,String memberId,String status);
Future<Either<Failure,List<ActivityParticipants>>> getAllParticipants(String activityId);
Future<Either<Failure,List<ActivityGuest>>> getAllguestOfActivity(String activityId);
Future<Either<Failure,List<Guest>>> getAllguest(bool isupdated);
Future<Either<Failure,ActivityGuest>> addGuest(String activityId,Guest guest);
Future<Either<Failure,Unit>> addGuestToActivity(String activityId,String guestId);
Future<Either<Failure,Unit>> deleteGuest(String activityId,String guestId);
Future<Either<Failure,Unit>> ChangeGuestToMember(String guestId);
Future<Either<Failure,Unit>> updateGuest(String activityId,Guest guest);
Future<Either<Failure,Unit>> updateGuestStatus(String activityId,String guestid,String status);
Future<Either<Failure,Unit>> SendRemiderActivity(String activityId);
  Future<Either<Failure, bool>> CheckPermissions(activity act);

}