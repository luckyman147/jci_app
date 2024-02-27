import 'package:dartz/dartz.dart';
import 'package:jci_app/core/usescases/usecase.dart';

import '../../../../core/error/Failure.dart';
import '../entities/Meeting.dart';
import '../repsotories/meetingRepo.dart';


class GetALlMeetingsUseCase extends UseCase<List<Meeting>,NoParams> {
  @override
  Future<Either<Failure, List<Meeting>>> call(NoParams params)async  {
    return await MeetingRepository.getAllMeetings();
  }

  final MeetingRepo MeetingRepository;

  GetALlMeetingsUseCase({ required this.MeetingRepository});


}
class GetMeetingByIdUseCase {
  final MeetingRepo MeetingRepository;

  GetMeetingByIdUseCase({ required this.MeetingRepository});

  Future<Either<Failure,Meeting>> call(String id) async {
    return await MeetingRepository.getMeetingById(id);
  }
}
class GetMeetingsOfTheWeekUseCase extends UseCase<List<Meeting>,NoParams>{
  final MeetingRepo MeetingRepository;

  GetMeetingsOfTheWeekUseCase({required this.MeetingRepository});
  @override
  Future<Either<Failure,List<Meeting>>> call(NoParams params) async {
    return await MeetingRepository.getMeetingsOfTheWeek();
  }
}

class CreateMeetingUseCase extends UseCase<Unit,Meeting> {
  final MeetingRepo MeetingRepository;

  CreateMeetingUseCase(this.MeetingRepository);

  Future<Either<Failure,Unit>> call(Meeting Meeting) async {
    return await MeetingRepository.createMeeting(Meeting);
  }
}
class UpdateMeetingUseCase {
  final MeetingRepo MeetingRepository;

  UpdateMeetingUseCase(this.MeetingRepository);

  Future<Either<Failure,Meeting>> call(Meeting Meeting) async {
    return await MeetingRepository.updateMeeting(Meeting);
  }
}
class DeleteMeetingUseCase {
  final MeetingRepo MeetingRepository;

  DeleteMeetingUseCase(this.MeetingRepository);

  Future<Either<Failure,Meeting>> call(String id) async {
    return await MeetingRepository.deleteMeeting(id);
  }
}
class LeaveMeetingUseCase {
  final MeetingRepo MeetingRepository;

  LeaveMeetingUseCase(this.MeetingRepository);

  Future<Either<Failure,bool>> call(String id) async {
    return await MeetingRepository.leaveMeeting(id);
  }
}

