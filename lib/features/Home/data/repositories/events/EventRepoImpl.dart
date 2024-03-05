import 'package:dartz/dartz.dart';

import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/network/network_info.dart';
import 'package:jci_app/features/Home/data/datasources/events/Event_local_datasources.dart';
import 'package:jci_app/features/Home/data/datasources/events/event_remote_datasources.dart';


import 'package:jci_app/features/Home/domain/entities/Event.dart';

import '../../../../../core/error/Exception.dart';
import '../../../domain/repsotories/EventRepo.dart';
import '../../model/events/EventModel.dart';
typedef Future<Unit> eventAction();
class EventRepoImpl implements EventRepo{
  final EventRemoteDataSource eventRemoteDataSource;
  final EventLocalDataSource eventLocalDataSource;
  final NetworkInfo networkInfo;

  EventRepoImpl({required this.eventRemoteDataSource, required this.eventLocalDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, Unit>> createEvent(Event event)async  {
    final eventMode= EventModel(
    id: event.id,
    LeaderName: event.LeaderName,
    name: event.name,
    description: event.description,
    ActivityBeginDate: event.ActivityBeginDate,
    ActivityEndDate: event.ActivityEndDate,
    ActivityAdress: event.ActivityAdress,
    ActivityPoints:0,
    categorie: event.categorie,
    IsPaid: event.IsPaid,
    price: event.price,
    Participants: [],
    CoverImages: event.CoverImages,
    registrationDeadline: event.registrationDeadline,
  );
    if (await networkInfo.isConnected) {
      try {
        await eventRemoteDataSource.createEvent(eventMode);
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
  Future<Either<Failure, Unit>> deleteEvent(String id)async {

    return await _getMessage(eventRemoteDataSource.deleteEvent(id));

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
  Future<Either<Failure, List<Event>>> getEventsOfTheMonth() async {
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
  Future<Either<Failure,List< Event>>> getEventsOfTheWeek() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteEvents = await eventRemoteDataSource.getEventsOfTheWeek();
        eventLocalDataSource.cacheEventsOfTheWeek(remoteEvents);
        print("here is the remote events $remoteEvents");
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
  Future<Either<Failure, Event>> getEventById(String id)async  {
    try {
      final event =await eventRemoteDataSource.getEventById(id);
      return Right(event);
    } on EmptyDataException {
      return Left(EmptyDataFailure());
    }
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
  Future<Either<Failure, Unit>> updateEvent(Event event)async {
    final eventMode= EventModel(
      id: event.id,
      LeaderName: event.LeaderName,
      name: event.name,
      description: event.description,
      ActivityBeginDate: event.ActivityBeginDate,
      ActivityEndDate: event.ActivityEndDate,
      ActivityAdress: event.ActivityAdress,
      ActivityPoints:0,
      categorie: event.categorie,
      IsPaid: event.IsPaid,
      price: event.price,
      Participants: [],
      CoverImages: event.CoverImages,
      registrationDeadline: event.registrationDeadline,
    );
    return await _getMessage(eventRemoteDataSource.updateEvent(eventMode));
  }
  Future<Either<Failure, Unit>> _getMessage(
      Future<Unit> event) async {
    if (await networkInfo.isConnected) {
      try {
        await event;
        return Right(unit);
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