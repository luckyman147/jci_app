import 'package:dartz/dartz.dart';
import 'package:jci_app/features/Home/domain/repsotories/EventRepo.dart';

import '../../../../core/error/Failure.dart';
import '../../presentation/bloc/Activity/activity_cubit.dart';
import '../entities/Activity.dart';
import '../entities/Meeting.dart';

abstract class MeetingRepo  {
  Future<Either<Failure, List<Meeting>>> getAllMeetings();
  Future<Either<Failure, Meeting>> getMeetingById(String id);

  Future<Either<Failure, List<Meeting>>> getMeetingsOfTheWeek();

  Future<Either<Failure, Unit>> createMeeting(Meeting Meeting);

  Future<Either<Failure, Unit>> updateMeeting(Meeting Meeting);

  Future<Either<Failure, Unit>> deleteMeeting(String id);

  Future<Either<Failure, Unit>> leaveMeeting(String id);
  Future<Either<Failure, bool>> CheckPermissions();

  Future<Either<Failure, Unit>> participateMeeting(String id);

  Future<Either<Failure, Meeting>> getMeetingLikes(String id);

  Future<Either<Failure, Meeting>> getMeetingParticipants(String id);


}