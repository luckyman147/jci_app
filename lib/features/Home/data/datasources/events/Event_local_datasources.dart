    import 'package:dartz/dartz.dart';
import 'package:jci_app/core/config/services/EventStore.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/features/Home/data/model/EvenetOfTheWeekModel.dart';
import 'package:jci_app/features/Home/data/model/EventOtheMonthModel.dart';

import '../../model/EventModel.dart';

          abstract class EventLocalDataSource {
  Future<List<EventModel>> getAllCachedEvents();
  Future<EventModel> getCachedEventById(String id);
  Future<List<EventOftheWeekModel>> getCachedEventsOfTheWeek();
  Future<List<EventOftheMonthModel>> getCachedEventsOfTheMonth();

  Future<Unit> cacheEvents(List<EventModel> event);
  Future<Unit> cacheEventsOfTheWeek(List<EventOftheWeekModel> event);
  Future<Unit> cacheEventsOfTheMonth(List<EventOftheMonthModel> event);


}

class EventLocalDataSourceImpl implements EventLocalDataSource{
  @override
  Future<Unit> cacheEvents(List<EventModel> event)async {
    await EventStore.cacheEvents(event);
    return Future.value(unit);
  }

  @override
  Future<Unit> cacheEventsOfTheMonth(List<EventOftheMonthModel> event) async {
    await EventStore.cacheEventsOfTheMonth(event);
    return Future.value(unit);
  }

  @override
  Future<Unit> cacheEventsOfTheWeek(List<EventOftheWeekModel> event) async {
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
  Future<List<EventOftheMonthModel>> getCachedEventsOfTheMonth() async{
    final events=await EventStore.getCachedEventsOfTheMonth();
    if (events.isNotEmpty) {
      return events;
    } else {
      throw EmptyCacheException();
    }


  }

  @override
  Future<List<EventOftheWeekModel>> getCachedEventsOfTheWeek()async {
    final events=await EventStore.getCachedEventsOfTheWeek();
    if (events.isNotEmpty) {
      return events;
    } else {
      throw EmptyCacheException();
    }


  }
}