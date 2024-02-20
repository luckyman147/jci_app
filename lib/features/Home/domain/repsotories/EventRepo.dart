import 'package:dartz/dartz.dart';

import '../../../../core/error/Failure.dart';
import '../entities/Event.dart';

abstract class EventRepo{
  Future<Either<Failure, List<Event>>> getAllEvents();
  Future<Either<Failure, Event>> getEventById(String id);
  Future<Either<Failure, List<Event>>> getEventsOfTheWeek();
  Future<Either<Failure, List<Event>>> getEventsOfTheMonth();

  Future<Either<Failure, Unit>> createEvent(Event event);
  Future<Either<Failure, Event>> updateEvent(Event event);
  Future<Either<Failure, Event>> deleteEvent(String id);

  Future<Either<Failure, bool>> leaveEvent(String id);
  Future<Either<Failure, bool>> participateEvent(String id);
  //Future<Either<Failure, Event>> likeEvent(String id);

  //Future<Either<Failure, Event>> commentEvent(String id, String comment);
  //Future<Either<Failure, Event>> deleteCommentEvent(String id, String commentId);
 // Future<Either<Failure, Event>> reportEvent(String id, String report);
  //uture<Either<Failure, Event>> deleteReportEvent(String id, String reportId);

  //Future<Either<Failure, Event>> getEventComments(String id);
  Future<Either<Failure, Event>> getEventLikes(String id);
  Future<Either<Failure, Event>> getEventParticipants(String id);

  //Future<Either<Failure, Event>> getEventComments(String id);

  Future<Either<Failure, Event>> getEventReports(String id);





}