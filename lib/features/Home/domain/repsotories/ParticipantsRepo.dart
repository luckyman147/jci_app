import 'package:dartz/dartz.dart';
import 'package:jci_app/features/Home/domain/entities/ParticipantDetailsParam.dart';

import '../../../../core/PrimitiveUser/User.dart';
import '../../../../core/error/Failure.dart';



abstract class ParticipantsRepository {
  Future<Either<Failure, Unit>> checkAbsence(String activityId, String memberId, String status);
  Future<Either<Failure, Unit>> updateMembersAttendance(String activityId, List<ParticipantDetailsParam> members);
  Future<Either<Failure, List<User>>> getAllParticipants();
  Future<Either<Failure, List<ParticipantDetailsParam>>> GetParticipantsOfActivity(String ActivityId);



  Future<Either<Failure, Unit>> sendReminderActivity(String ActivityName, String ActivityBeginDate ,String location);
}
