    import 'package:dartz/dartz.dart';
import 'package:jci_app/core/config/services/EventStore.dart';
import 'package:jci_app/core/error/Exception.dart';


import '../../model/events/EventModel.dart';


          abstract class EventLocalDataSource {
  Future<List<EventModel>> getAllCachedEvents();
  Future<List<String>> getPermissions();

  Future<List<EventModel>> getCachedEventsOfTheWeek();
  Future<List<EventModel>> getCachedEventsOfTheMonth();

  Future<Unit> cacheEvents(List<EventModel> event);
  Future<Unit> cacheEventsOfTheWeek(List<EventModel> event);
  Future<Unit> cacheEventsOfTheMonth(List<EventModel> event);

  Future<Unit> CacheEventById(EventModel result) ;
  Future<EventModel?> getEventById(String id);


}

class EventLocalDataSourceImpl implements EventLocalDataSource{
  @override
  Future<Unit> cacheEvents(List<EventModel> event)async {
    await EventStore.cacheEvents(event);
    return Future.value(unit);
  }

  @override
  Future<Unit> cacheEventsOfTheMonth(List<EventModel> event) async {
await EventStore.cacheEvents(event);
    return Future.value(unit);
  }

  @override
  Future<Unit> cacheEventsOfTheWeek(List<EventModel> event) async {
throw UnimplementedError();

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
  Future<List<EventModel>> getCachedEventsOfTheMonth() async{
 final events=await EventStore.getCachedEvents();
    if (events.isNotEmpty) {
      return events;
    } else {
      throw EmptyCacheException();
    }



  }

  @override
  Future<List<EventModel>> getCachedEventsOfTheWeek()async {
throw UnimplementedError();
  }

  @override
  Future<List<String>> getPermissions() async {
  final permissions=await EventStore.getEventPermissions();
  if (permissions.isNotEmpty) {
    return permissions;
  } else {
    return [];
  }}

  @override
  Future<Unit> CacheEventById(EventModel result) async{
    await EventStore.cacheEventById(result);
    return Future.value(unit);
  }

  @override
  Future<EventModel?> getEventById(String id) async{
    final event=await EventStore.getEventById(id);
    if
    (event!=null) {
      return event;
    } else {
      return null;
    }
  }
}