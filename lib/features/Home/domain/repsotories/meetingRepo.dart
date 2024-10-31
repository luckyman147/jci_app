import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import 'package:jci_app/features/Home/domain/entities/Note.dart';

import '../../../../core/error/Failure.dart';
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
  Future<Either<Failure,List<Note>>> getAllNotes(String activityId,String start,String limit,bool isUpdated);
  Future<Either<Failure,Note>> addNotes(String activityId,Note note);
  Future<Either<Failure,Unit>> deleteNotes(String activityId,String noteId);
  Future<Either<Failure,Uint8List>> downloadExcel(String activityId);
  Future<Either<Failure,Unit>> UpdateNotes(Note note);
  Future<Either<Failure,Unit>>saveExcelFile(Uint8List file, String filename);


}