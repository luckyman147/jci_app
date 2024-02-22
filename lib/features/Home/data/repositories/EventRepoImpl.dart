import 'package:dartz/dartz.dart';

import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/network/network_info.dart';
import 'package:jci_app/features/Home/data/datasources/events/Event_local_datasources.dart';
import 'package:jci_app/features/Home/data/datasources/events/event_remote_datasources.dart';


import 'package:jci_app/features/Home/domain/entities/Event.dart';

import '../../../../core/error/Exception.dart';
import '../../domain/repsotories/EventRepo.dart';

class EventRepoImpl implements EventRepo{
  final EventRemoteDataSource eventRemoteDataSource;
  final EventLocalDataSource eventLocalDataSource;
  final NetworkInfo networkInfo;

  EventRepoImpl({required this.eventRemoteDataSource, required this.eventLocalDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, Unit>> createEvent(Event event) {
    // TODO: implement createEvent
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Event>> deleteEvent(String id) {
    // TODO: implement deleteEvent
    throw UnimplementedError();
  }





  //
  @override
  Future<Either<Failure, List<Event>>> getAllEvents()async {
if (await networkInfo.isConnected) {
      try {
        final remoteEvents = await eventRemoteDataSource.getAllEvents();
        eventLocalDataSource.cacheEvents(remoteEvents);
        return Right(remoteEvents);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localEvents = await eventLocalDataSource.getAllCachedEvents();
        return Right(localEvents);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }
@override
  Future<Either<Failure, List<EventOfTheMonth>>> getEventsOfTheMonth() async {
if (await networkInfo.isConnected) {
      try {
        final remoteEvents = await eventRemoteDataSource.getEventsOfTheMonth();
        eventLocalDataSource.cacheEventsOfTheMonth(remoteEvents);
        return Right(remoteEvents);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
  try {
    final localEvents = await eventLocalDataSource.getCachedEventsOfTheMonth();
    return Right(localEvents);
  } on EmptyCacheException {
    return Left(EmptyCacheFailure());
  }
}

  }

  @override
  Future<Either<Failure,List< EventOfTheWeek>>> getEventsOfTheWeek() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteEvents = await eventRemoteDataSource.getEventsOfTheWeek();
        eventLocalDataSource.cacheEventsOfTheWeek(remoteEvents);
        return Right(remoteEvents);
      } on EmptyDataException {
        return Left(EmptyDataFailure());
      }
    } else {
    try {
    final localEvents = await eventLocalDataSource.getCachedEventsOfTheWeek();
    return Right(localEvents);
    } on EmptyCacheException {
    return Left(EmptyCacheFailure());
    }
    }

  }
  @override
  Future<Either<Failure, Event>> getEventById(String id) {
    // TODO: implement getEventById
    throw UnimplementedError();
  }






  @override
  Future<Either<Failure, Event>> getEventLikes(String id) {
    // TODO: implement getEventLikes
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Event>> getEventParticipants(String id) {
    // TODO: implement getEventParticipants
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Event>> getEventReports(String id) {
    // TODO: implement getEventReports
    throw UnimplementedError();
  }

  @override



  @override
  Future<Either<Failure, bool>> leaveEvent(String id) {
    // TODO: implement leaveEvent
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> participateEvent(String id) {
    // TODO: implement participateEvent
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Event>> updateEvent(Event event) {
    // TODO: implement updateEvent
    throw UnimplementedError();
  }
  
}