import 'package:dartz/dartz.dart';
import 'package:jci_app/core/PrimitiveUser/User.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/usescases/usecase.dart';
import 'package:jci_app/features/Home/domain/Dtos/ActivityParam.dart';
import 'package:jci_app/features/Home/domain/Dtos/PArticipantParam.dart';
import 'package:jci_app/features/Home/domain/entities/ParticipantDetailsParam.dart';
import 'package:jci_app/features/Home/domain/repsotories/ParticipantsRepo.dart';

import '../Dtos/UpdateParticpantsStatus.dart';

class CheckAbsenceUseCases extends UseCase<Unit,ParticipantsParams > {
  final ParticipantsRepository participantsRepository;

  CheckAbsenceUseCases({required this.participantsRepository});

  @override
  Future<Either<Failure, Unit>> call(ParticipantsParams params) {
    return participantsRepository.checkAbsence(params.ActivityId!, params.partipantId, params.status.name);
  }
}
class UpdateMembersAttendanceUseCases extends UseCase<Unit,UpdateMembersAttendanceParams > {
  final ParticipantsRepository participantsRepository;

  UpdateMembersAttendanceUseCases({required this.participantsRepository});

  @override
  Future<Either<Failure, Unit>> call(UpdateMembersAttendanceParams params) {
    return participantsRepository.updateMembersAttendance(params.ActivityId, params.members);
  }
}


class GetParticipantsOfActivityUseCases extends UseCase<List<ParticipantDetailsParam>,String > {
  final ParticipantsRepository participantsRepository;

  GetParticipantsOfActivityUseCases({required this.participantsRepository});

  @override
  Future<Either<Failure, List<ParticipantDetailsParam>>> call( params) {
    return participantsRepository.GetParticipantsOfActivity(params);
  }
}
class GetAllParticipantsUseCases extends UseCase<List<User>,NoParams > {
  final ParticipantsRepository participantsRepository;

  GetAllParticipantsUseCases({required this.participantsRepository});

  @override
  Future<Either<Failure, List<User>>> call( params) {
    return participantsRepository.getAllParticipants();
  }
}
class SendReminderUseCases extends UseCase<Unit,ReminderParams > {
  final ParticipantsRepository activitiesRepo;

  SendReminderUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, Unit>> call( params) {
    return activitiesRepo.sendReminderActivity(params.ActivityName, params.ActivityBeginDate, params.location);
  }
}
