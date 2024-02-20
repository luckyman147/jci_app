    import 'package:dartz/dartz.dart';
import 'package:jci_app/core/config/services/EventStore.dart';
import 'package:jci_app/core/error/Exception.dart';

import '../../model/EventModel.dart';

          abstract class EventLocalDataSource {
  Future<List<EventModel>> getAllCachedEvents();
  Future<EventModel> getCachedEventById(String id);
  Future<List<EventModel>> getCachedEventsOfTheWeek();
  Future<List<EventModel>> getCachedEventsOfTheMonth();

  Future<Unit> cacheEvents(List<EventModel> event);
  Future<Unit> cacheEventsOfTheWeek(List<EventModel> event);
  Future<Unit> cacheEventsOfTheMonth(List<EventModel> event);


}

class EventLocalDataSourceImpl implements EventLocalDataSource{
  @override
  Future<Unit> cacheEvents(List<EventModel> event)async {
    await EventStore.cacheEvents(event);
    return Future.value(unit);
  }

  @override
  Future<Unit> cacheEventsOfTheMonth(List<EventModel> event) async {
    await EventStore.cacheEventsOfTheMonth(event);
    return Future.value(unit);
  }

  @override
  Future<Unit> cacheEventsOfTheWeek(List<EventModel> event) async {
    await EventStore.cacheEventsOfTheWeek(event);
    return Future.value(unit);


  }

  @override
  Future<List<EventModel>> getAllCachedEvents() async {
 final events=await EventStore.getCachedEvents();
    if (events.isNotEmpty) {
      return events;
    } else {
      throw EmptyCacheException();
    }
  }

  @override
  Future<EventModel> getCachedEventById(String id) {
    // TODO: implement getCachedEventById
    throw UnimplementedError();
  }

  @override
  Future<List<EventModel>> getCachedEventsOfTheMonth() async{
    final events=await EventStore.getCachedEventsOfTheMonth();
    if (events.isNotEmpty) {
      return events;
    } else {
      throw EmptyCacheException();
    }


  }

  @override
  Future<List<EventModel>> getCachedEventsOfTheWeek()async {
    final events=await EventStore.getCachedEventsOfTheWeek();
    if (events.isNotEmpty) {
      return events;
    } else {
      throw EmptyCacheException();
    }


  }
}