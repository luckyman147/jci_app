import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:jci_app/core/usescases/usecase.dart';

import '../../../../core/error/Failure.dart';
import '../entities/Meeting.dart';
import '../entities/Note.dart';
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
class UpdateMeetingUseCase extends UseCase<Unit,Meeting>{
  final MeetingRepo MeetingRepository;

  UpdateMeetingUseCase(this.MeetingRepository);

  Future<Either<Failure,Unit>> call(Meeting Meeting) async {
    return await MeetingRepository.updateMeeting(Meeting);
  }
}
class DeleteMeetingUseCase  extends UseCase<Unit,String>{
  final MeetingRepo MeetingRepository;

  DeleteMeetingUseCase(this.MeetingRepository);

  Future<Either<Failure,Unit>> call(String id) async {
    return await MeetingRepository.deleteMeeting(id);
  }
}
class LeaveMeetingUseCase {
  final MeetingRepo MeetingRepository;

  LeaveMeetingUseCase(this.MeetingRepository);

  Future<Either<Failure,Unit>> call(String id) async {
    return await MeetingRepository.leaveMeeting(id);
  }
}class ParticipateMeetingUseCase extends UseCase<Unit,String> {
  final MeetingRepo MeetingRepository;

  ParticipateMeetingUseCase(this.MeetingRepository);

  Future<Either<Failure,Unit>> call(String id) async {
    return await MeetingRepository.participateMeeting(id);
  }
}
class CheckMeetPermissionsUseCase {
  final MeetingRepo MeetingRepository;

  CheckMeetPermissionsUseCase(this.MeetingRepository);

  Future<Either<Failure,bool>> call() async {
    return await MeetingRepository.CheckPermissions();
  }
}
class GetNotesOfActivityUseCase {
  final MeetingRepo MeetingRepository;

  GetNotesOfActivityUseCase(this.MeetingRepository);

  Future<Either<Failure,List<Note>>> call(String activityId,bool isUpdated,{String start="0",String limit="4"}) async {
    return await MeetingRepository.getAllNotes(activityId, start, limit, isUpdated);
  }
}class CreateNotesUseCases extends UseCase<Note,NoteInput> {
  final MeetingRepo MeetingRepository;

  CreateNotesUseCases(this.MeetingRepository);

  Future<Either<Failure,Note>> call(param) async {
    return await MeetingRepository.addNotes(param.activityId,param.note!);
  }
}

class UpdateNotesUseCases extends UseCase<Unit,Note> {
  final MeetingRepo MeetingRepository;

  UpdateNotesUseCases(this.MeetingRepository);

  Future<Either<Failure,Unit>> call(param) async {
    return await MeetingRepository.UpdateNotes(param);
  }
}

class DeleteNotesUseCases extends UseCase<Unit,NoteInput> {
  final MeetingRepo MeetingRepository;

  DeleteNotesUseCases(this.MeetingRepository);

  Future<Either<Failure,Unit>> call(params) async {
    return await MeetingRepository.deleteNotes(params.activityId,params.noteid!);
  }
}
class DownloadExcelUseCases extends UseCase<Uint8List,String> {
  final MeetingRepo repository;

  DownloadExcelUseCases(this.repository);

  Future<Either<Failure,Uint8List>> call(String url) async {
return await repository.downloadExcel(url);

  }
}

class NoteInput{
  final String activityId;
  final Note? note;
  final String? noteid;

  NoteInput(this.activityId, this.note, this.noteid, );
}


