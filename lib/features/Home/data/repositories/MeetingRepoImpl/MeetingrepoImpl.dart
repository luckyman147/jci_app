import 'package:dartz/dartz.dart';

import '../../../../../core/error/Exception.dart';
import '../../../../../core/error/Failure.dart';
import '../../../../../core/network/network_info.dart';
import '../../../domain/entities/Meeting.dart';
import '../../../domain/repsotories/meetingRepo.dart';
import '../../datasources/Meetings/MeetingLocaldatasources.dart';
import '../../datasources/Meetings/Meeting_remote_datasources.dart';
import '../../model/meetingModel/MeetingModel.dart';


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
      Participants: [],
      CoverImages: meeting.CoverImages, Director: meeting.Director, agenda: meeting.agenda,


    );
    if (await networkInfo.isConnected) {
      try {
        await meetingRemoteDataSource.createMeeting(eventMode);
        return Right(unit);
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
  Future<Either<Failure, Meeting>> deleteMeeting(String id) {
    // TODO: implement deleteMeeting
    throw UnimplementedError();
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
  Future<Either<Failure, bool>> leaveMeeting(String id) {
    // TODO: implement leaveMeeting
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> participateMeeting(String id) {
    // TODO: implement participateMeeting
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Meeting>> updateMeeting(Meeting Meeting) {
    // TODO: implement updateMeeting
    throw UnimplementedError();
  }
}
