import 'package:dartz/dartz.dart';

import '../../../../core/error/Failure.dart';
import '../entities/Event.dart';

abstract class EventRepo{
  Future<Either<Failure, List<Event>>> getAllEvents();
  Future<Either<Failure, Event>> getEventById(String id);
  Future<Either<Failure, List<Event>>> getEventsOfTheWeek();
  Future<Either<Failure, List<Event>>> getEventsOfTheMonth();
  Future<Either<Failure, Unit>> createEvent(Event event);
  Future<Either<Failure, Unit>> updateEvent(Event event);
  Future<Either<Failure, Unit>> deleteEvent(String id);
  Future<Either<Failure, Unit>> leaveEvent(String id);
  Future<Either<Failure, Unit>> participateEvent(String id);
  Future<Either<Failure, Event>> getEventLikes(String id);
  Future<Either<Failure, Event>> getEventParticipants(String id);
  Future<Either<Failure, Event>> getEventReports(String id);
  Future<Either<Failure, bool>> CheckPermissions();







}