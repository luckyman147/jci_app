import 'dart:developer';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:jci_app/core/config/services/MeetingStore.dart';
import 'package:jci_app/features/Home/data/model/NoteModel.dart';
import 'package:jci_app/features/Home/domain/entities/Note.dart';

import '../../../../../core/config/services/store.dart';
import '../../../../../core/config/services/verification.dart';
import '../../../../../core/error/Exception.dart';
import '../../../../../core/error/Failure.dart';
import '../../../../../core/network/network_info.dart';
import '../../../domain/entities/Meeting.dart';
import '../../../domain/repsotories/meetingRepo.dart';
import '../../datasources/Meetings/MeetingLocaldatasources.dart';
import '../../datasources/Meetings/Meeting_remote_datasources.dart';
import '../../model/meetingModel/MeetingModel.dart';

typedef meetingAction = Future<Unit> Function();
class MeetingRepoImpl implements MeetingRepo {
  final MeetingRemoteDataSource meetingRemoteDataSource;
  final MeetingLocalDataSource meetingLocalDataSource;
  final NetworkInfo networkInfo;

  MeetingRepoImpl(
      {required this.meetingRemoteDataSource, required this.meetingLocalDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, Unit>> createMeeting(Meeting meeting)  async {


    final eventMode= MeetingModel(
id: meeting.id,

      name: meeting.name,
      description: meeting.description,
      ActivityBeginDate: meeting.ActivityBeginDate,
      ActivityEndDate: meeting.ActivityEndDate,
      ActivityAdress: meeting.ActivityAdress,
      ActivityPoints: meeting.ActivityPoints,
      categorie: meeting.categorie,
      IsPaid: meeting.IsPaid,
      price: meeting.price,
      Participants: const [],
      CoverImages: meeting.CoverImages, Director: meeting.Director, agenda: meeting.agenda, IsPart: false,


    );
    if (await networkInfo.isConnected) {
      try {
        await meetingRemoteDataSource.createMeeting(eventMode);
        return const Right(unit);
      } on WrongCredentialsException {
        return Left(WrongCredentialsFailure());
      }

      on ServerException {
        return Left(ServerFailure());
      }
      on EmptyDataException{
        return Left(EmptyDataFailure());
      }
    } else {
      return Left(OfflineFailure());
    }

  }

  @override
  Future<Either<Failure, Unit>> deleteMeeting(String id)async {
  return await (getMessage(meetingRemoteDataSource.deleteMeeting(id)));
  }


  //
  @override
  Future<Either<Failure, List<Meeting>>> getAllMeetings() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMeetings = await meetingRemoteDataSource.getAllMeetings();
        meetingLocalDataSource.cacheMeetings(remoteMeetings);
        return Right(remoteMeetings);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localMeetings = await meetingLocalDataSource
            .getAllCachedMeetings();
        return Right(localMeetings);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }


  @override
  Future<Either<Failure, List<Meeting>>> getMeetingsOfTheWeek() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMeetings = await meetingRemoteDataSource
            .getMeetingsOfTheWeek();
        meetingLocalDataSource.cacheMeetingsOfTheWeek(remoteMeetings);
        return Right(remoteMeetings);
      } on EmptyDataException {
        return Left(EmptyDataFailure());
      }
    } else {
      try {
        final localMeetings = await meetingLocalDataSource
            .getCachedMeetingsOfTheWeek();
        return Right(localMeetings);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Meeting>> getMeetingById(String id)async  {
    try {
      final meeting =await meetingRemoteDataSource.getMeetingById(id);
      return Right(meeting);
    } on EmptyDataException {
      return Left(EmptyDataFailure());
    }
  }


  @override
  Future<Either<Failure, Meeting>> getMeetingLikes(String id) {
    // TODO: implement getMeetingLikes
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Meeting>> getMeetingParticipants(String id) {
    // TODO: implement getMeetingParticipants
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Meeting>> getMeetingReports(String id) {
    // TODO: implement getMeetingReports
    throw UnimplementedError();
  }

  @override
  @override
  Future<Either<Failure, Unit>> leaveMeeting(String id) async {
    return await (getMessage(meetingRemoteDataSource.leaveMeeting(id)));
  }

  @override
  Future<Either<Failure, Unit>> participateMeeting(String id) async{
 return await (getMessage(meetingRemoteDataSource.participateMeeting(id)));
  }

  @override
  Future<Either<Failure, Unit>> updateMeeting(Meeting meeting) async{
    final eventMode= MeetingModel(
      id: meeting.id,

      name: meeting.name,
      description: meeting.description,
      ActivityBeginDate: meeting.ActivityBeginDate,
      ActivityEndDate: meeting.ActivityEndDate,
      ActivityAdress: meeting.ActivityAdress,
      ActivityPoints: meeting.ActivityPoints,
      categorie: meeting.categorie,
      IsPaid: meeting.IsPaid,
      price: meeting.price,
      Participants: meeting.Participants,
      CoverImages: meeting.CoverImages, Director: meeting.Director, agenda: meeting.agenda, IsPart: meeting.IsPart


    );
    return await (getMessage(meetingRemoteDataSource.updateMeeting(eventMode)));
  }
  Future<Either<Failure, Unit>> getMessage(
      Future<Unit> meeting) async {
    if (await networkInfo.isConnected) {
      try {
        await meeting;
        return const Right(unit);
      }

      on EmptyDataException {
        return Left(EmptyDataFailure());
      } on WrongCredentialsException {
        return Left(WrongCredentialsFailure());
      }
      on ServerException {
        return Left(ServerFailure());
      }
    }


    else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> CheckPermissions() async {
    final eventPermission=await  MeetingStore.getmeetPermissions();
    final userPermissions=await Store.getPermissions();
    if(eventPermission .isEmpty || userPermissions.isEmpty){
      return const Right(false);
    }
    else{

      return hasCommonElement(eventPermission, userPermissions)?const Right(true):const Right(false);
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getAllNotes(String activityId, String start, String limit,bool isUpdated) async{
    if (await networkInfo.isConnected) {

     // final cachedNotes = await meetingLocalDataSource.getNotes(start,limit);

      try {
        log("dddd");
        final remoteNotes = await meetingRemoteDataSource.getModelNotesOfActivity(activityId,start,limit);
        meetingLocalDataSource.cacheNotes(remoteNotes,start,limit);
        return Right(remoteNotes);
      } on ServerException {

        return Left(ServerFailure());
      }
    } else {
      try {
        final localNotes = await meetingLocalDataSource
            .getNotes(start,limit);
        return Right(localNotes);
      } on EmptyCacheException {
        if (await networkInfo.isConnected) {
          return Left(EmptyDataFailure());
        } else {
          return Left(OfflineFailure());
        }
      }


    }
  }

  @override
  Future<Either<Failure, Unit>> UpdateNotes( Note note) async{
    final noteModel=NoteModel.fromEntity(note);
    return await (getMessage(meetingRemoteDataSource.UpdateNoteOfActivity(noteModel)));

  }

  @override
  Future<Either<Failure, Note>> addNotes(String activityId, Note note) async{
    final noteModel=NoteModel.fromEntity(note);
    if (await networkInfo.isConnected) {
      try {
        final remoteNote =await meetingRemoteDataSource.CreateNoteOfActivity(activityId,noteModel);
        return Right(remoteNote);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteNotes( String activityId,String noteId)async {
    return await (getMessage(meetingRemoteDataSource.DeleteNote(activityId,noteId)));

  }

  @override
  Future<Either<Failure, Uint8List>> downloadExcel(String activityId,)async {
   if (await networkInfo.isConnected) {
      try {
        final remoteExcel = await meetingRemoteDataSource.downloadExcel(activityId);
        log(remoteExcel.toString());
        meetingLocalDataSource.saveExcelFile(remoteExcel,"$activityId.xlsx");
        return Right(remoteExcel);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> saveExcelFile(Uint8List file, String filename)async {
    return await (getMessage(meetingLocalDataSource.saveExcelFile(file,filename)));


  }
}
