import 'package:dartz/dartz.dart';
import 'package:jci_app/core/usescases/usecase.dart';

import '../../../../core/error/Failure.dart';
import '../entities/Event.dart';
import '../repsotories/EventRepo.dart';

class GetALlEventsUseCase extends UseCase<List<Event>,NoParams> {
    @override
  Future<Either<Failure, List<Event>>> call(NoParams params)async  {
      return await eventRepository.getAllEvents();
  }

final EventRepo eventRepository;

  GetALlEventsUseCase({ required this.eventRepository});


}
class GetEventByIdUseCase {
  final EventRepo eventRepository;

  GetEventByIdUseCase({ required this.eventRepository});

  Future<Either<Failure,Event>> call(String id) async {
    return await eventRepository.getEventById(id);
  }
}
class GetEventsOfTheWeekUseCase extends UseCase<List<EventOfTheWeek>,NoParams>{
  final EventRepo eventRepository;

  GetEventsOfTheWeekUseCase({required this.eventRepository});
@override
  Future<Either<Failure,List<EventOfTheWeek>>> call(NoParams params) async {
    return await eventRepository.getEventsOfTheWeek();
  }
}
class GetEventsOfTheMonthUseCase extends UseCase<List<EventOfTheMonth>,NoParams>{
  final EventRepo eventRepository;

  GetEventsOfTheMonthUseCase({ required this.eventRepository});
@override
  Future<Either<Failure,List<EventOfTheMonth>>> call(NoParams params ) async {
    return await eventRepository.getEventsOfTheMonth();
  }
}
class CreateEventUseCase extends UseCase<Unit,Event> {
  final EventRepo eventRepository;

  CreateEventUseCase(this.eventRepository);

  Future<Either<Failure,Unit>> call(Event event) async {
    return await eventRepository.createEvent(event);
  }
}
class UpdateEventUseCase {
  final EventRepo eventRepository;

  UpdateEventUseCase(this.eventRepository);

  Future<Either<Failure,Event>> call(Event event) async {
    return await eventRepository.updateEvent(event);
  }
}
class DeleteEventUseCase {
  final EventRepo eventRepository;

  DeleteEventUseCase(this.eventRepository);

  Future<Either<Failure,Event>> call(String id) async {
    return await eventRepository.deleteEvent(id);
  }
}
class LeaveEventUseCase {
  final EventRepo eventRepository;

  LeaveEventUseCase(this.eventRepository);

  Future<Either<Failure,bool>> call(String id) async {
    return await eventRepository.leaveEvent(id);
  }
}

