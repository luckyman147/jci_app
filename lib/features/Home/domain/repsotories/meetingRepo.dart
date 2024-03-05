import 'package:dartz/dartz.dart';

import '../../../../core/error/Failure.dart';
import '../entities/Meeting.dart';

abstract class MeetingRepo {
  Future<Either<Failure, List<Meeting>>> getAllMeetings();

  Future<Either<Failure, Meeting>> getMeetingById(String id);

  Future<Either<Failure, List<Meeting>>> getMeetingsOfTheWeek();

  Future<Either<Failure, Unit>> createMeeting(Meeting Meeting);

  Future<Either<Failure, Unit>> updateMeeting(Meeting Meeting);

  Future<Either<Failure, Unit>> deleteMeeting(String id);

  Future<Either<Failure, bool>> leaveMeeting(String id);

  Future<Either<Failure, bool>> participateMeeting(String id);

  Future<Either<Failure, Meeting>> getMeetingLikes(String id);

  Future<Either<Failure, Meeting>> getMeetingParticipants(String id);

  Future<Either<Failure, Meeting>> getMeetingReports(String id);
}