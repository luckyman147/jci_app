import 'package:dartz/dartz.dart';

import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/features/Home/data/model/TrainingModel/TrainingModel.dart';
import 'package:jci_app/features/Home/data/model/meetingModel/MeetingModel.dart';

import 'package:jci_app/features/Home/domain/entities/Activity.dart';

import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';

import '../../../../core/error/Exception.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/Event.dart';
import '../../domain/entities/Meeting.dart';
import '../../domain/entities/training.dart';
import '../../domain/repsotories/ActivitiesRepo.dart';
import '../datasources/Meetings/MeetingLocaldatasources.dart';
import '../datasources/Meetings/Meeting_remote_datasources.dart';
import '../datasources/events/Event_local_datasources.dart';
import '../datasources/events/event_remote_datasources.dart';
import '../datasources/trainings/TrainingLocalDatasources.dart';
import '../datasources/trainings/Training_Remote_datasources.dart';
import '../model/events/EventModel.dart';

class ActivityRepoImpl implements ActivitiesRepo{
  final MeetingRemoteDataSource meetingRemoteDataSource;
  final MeetingLocalDataSource meetingLocalDataSource;
  final TrainingRemoteDataSource trainingRemoteDataSource;
  final TrainingLocalDataSource trainingLocalDataSource;
  final EventRemoteDataSource eventRemoteDataSource;
  final EventLocalDataSource eventLocalDataSource;
  final NetworkInfo networkInfo;

  ActivityRepoImpl(  {required this.meetingRemoteDataSource, required this.meetingLocalDataSource,
    required this.eventLocalDataSource,
    required this.trainingRemoteDataSource,
    required this.eventRemoteDataSource,
    required this.trainingLocalDataSource,



    required this.networkInfo});
  @override
  Future<Either<Failure, bool>> CheckPermissions(activity act) {
    // TODO: implement CheckPermissions
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> createEvent(Activity act,activity type) async {
    if (await networkInfo.isConnected) {
      try {

        switch(type){
          case activity.Events:
            final event=EventModel.fromEntity(act as Event);
       await eventRemoteDataSource.createEvent(event);

            return Right(unit);

          case activity.Meetings:
final result= MeetingModel.fromEntities(act as Meeting);
         await meetingRemoteDataSource.createMeeting(result);
            return Right(unit);
          case activity.Trainings:
            final result= TrainingModel.fromEntity(act as Training);
            await trainingRemoteDataSource.createTraining(result);
            return Right(unit);
        }


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
  Future<Either<Failure, Unit>> deleteEvent(String id, activity act) async {
    if (await networkInfo.isConnected) {
      try {

        switch(act){
          case activity.Events:
          await eventRemoteDataSource.deleteEvent(id);

            return Right(unit);

          case activity.Meetings:
    await meetingRemoteDataSource.deleteMeeting(id);
            return Right(unit);
          case activity.Trainings:
    await trainingRemoteDataSource.deleteTraining(id);

            return Right(unit);
        }


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
  Future<Either<Failure, Activity>> getActivityById(String id, activity act)async  {
    if (await networkInfo.isConnected) {
      try {

        switch(act){
          case activity.Events:
            final result=await eventRemoteDataSource.getEventById(id);

            return Right(result);

          case activity.Meetings:
            final result=await meetingRemoteDataSource.getMeetingById(id);

            return Right(result);
          case activity.Trainings:
            final result=await trainingRemoteDataSource.getTrainingById(id);

            return Right(result);
        }


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
      return Left(OfflineFailure ());
    }
  }

  @override
  Future<Either<Failure, List<Activity>>> getAllActvities(activity act)async  {

    if (await networkInfo.isConnected) {
      try {

        switch(act){
          case activity.Events:
            final result=await eventRemoteDataSource.getAllEvents();
            eventLocalDataSource.cacheEvents(result);
            return Right(result);

          case activity.Meetings:
            final result=await meetingRemoteDataSource.getAllMeetings();
            meetingLocalDataSource.cacheMeetings(result);
            return Right(result);
          case activity.Trainings:
             final result=await trainingRemoteDataSource.getAllTraining();
        trainingLocalDataSource.cacheTrainings(result);
        return Right(result);
        }


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
      switch (act) {
        case activity.Trainings:
          final localTrainings = await trainingLocalDataSource
              .getAllCachedTrainings();
          return Right(localTrainings);
        case activity.Meetings:
          final localTrainings = await meetingLocalDataSource
              .getAllCachedMeetings();
          return Right(localTrainings);
        case activity.Events:
          final localTrainings = await eventLocalDataSource
              .getAllCachedEvents();
          return Right(localTrainings);
      }
    }




  }

  @override
  Future<Either<Failure, Unit>> leaveEvent(String id, activity act)async  {
    if (await networkInfo.isConnected) {
      try {

        switch(act){
          case activity.Events:
            await eventRemoteDataSource.leaveEvent(id);

            return Right(unit);

          case activity.Meetings:
            await meetingRemoteDataSource.leaveMeeting(id);
            return Right(unit);
          case activity.Trainings:
            await trainingRemoteDataSource.leaveTraining(id);

            return Right(unit);
        }


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
  Future<Either<Failure, Unit>> participateEvent(String id, activity act)async  {
    if (await networkInfo.isConnected) {
      try {

        switch(act){
          case activity.Events:
            await eventRemoteDataSource.participateEvent(id);

            return Right(unit);

          case activity.Meetings:
            await meetingRemoteDataSource.participateMeeting(id);
            return Right(unit);
          case activity.Trainings:
            await trainingRemoteDataSource.participateTraining(id);

            return Right(unit);
        }


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
  Future<Either<Failure, Unit>> updateEvent(Activity act,activity type) async {
    if (await networkInfo.isConnected) {
      try {

        switch(type){
          case activity.Events:
            final event=EventModel.fromEntity(act as Event);
            await eventRemoteDataSource.updateEvent(event);

            return Right(unit);

          case activity.Meetings:
            final result= MeetingModel.fromEntities(act as Meeting);
            await meetingRemoteDataSource.updateMeeting(result);
            return Right(unit);
          case activity.Trainings:
            final result= TrainingModel.fromEntity(act as Training);
            await trainingRemoteDataSource.updateTraining(result);
            return Right(unit);
        }

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

}