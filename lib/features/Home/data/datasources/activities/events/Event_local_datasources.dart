import 'package:dartz/dartz.dart';
import 'package:jci_app/core/config/services/EventStore.dart';
import 'package:jci_app/core/config/services/store.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/features/Home/data/model/events/EventModel.dart';

import '../../../../../../core/config/services/verification.dart';

abstract class EventLocalDataSource {
  Future<List<EventModel>> getAllCachedEvents();
  Future<List<String>> getPermissions();

  Future<List<EventModel>> getCachedEventsOfTheWeek();
  Future<List<EventModel>> getCachedEventsOfTheMonth();

  Future<Unit> cacheEvents(List<EventModel> event);
  Future<Unit> cacheEventsOfTheWeek(List<EventModel> event);
  Future<Unit> cacheEventsOfTheMonth(List<EventModel> event);
  Future<bool> checkPermissions();
  Future<Unit> CacheEventById(EventModel result);
  Future<EventModel?> getEventById(String id);

  Future<void> deleteEvent(String id);

  Future<void> cacheEvent(EventModel event);
}

class EventLocalDataSourceImpl implements EventLocalDataSource {
  final Store store;
  final EventStore eventStore;

  EventLocalDataSourceImpl(this.eventStore, {required this.store});
  @override
  Future<Unit> cacheEvents(List<EventModel> event) async {
    await eventStore.cacheEvents(event);

    return Future.value(unit);
  }

  @override
  Future<Unit> cacheEventsOfTheMonth(List<EventModel> event) async {
    await eventStore.cacheEvents(event);
    return Future.value(unit);
  }

  @override
  Future<Unit> cacheEventsOfTheWeek(List<EventModel> event) async {
    throw UnimplementedError();
  }

  @override
  Future<List<EventModel>> getAllCachedEvents() async {
    final events = await eventStore.getCachedEvents();
    if (events.isNotEmpty) {
      //remove duplicates
      final uniqueEvents = events.toSet().toList();
      return uniqueEvents;
    } else {
      return [];
    }
  }

  @override
  Future<List<EventModel>> getCachedEventsOfTheMonth() async {
    final events = await eventStore.getCachedEvents();
    if (events.isNotEmpty) {
      return events;
    } else {
      throw EmptyCacheException();
    }
  }

  @override
  Future<List<EventModel>> getCachedEventsOfTheWeek() async {
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getPermissions() async {
    final permissions = await eventStore.getEventPermissions();
    if (permissions.isNotEmpty) {
      return permissions;
    } else {
      return [];
    }
  }

  @override
  Future<Unit> CacheEventById(EventModel result) async {
    await eventStore.cacheEventById(result);
    return Future.value(unit);
  }

  @override
  Future<EventModel?> getEventById(String id) async {
    final event = await eventStore.getEventById(id);
    if (event != null) {
      return event;
    } else {
      return null;
    }
  }

  @override
  Future<bool> checkPermissions() async {
    final eventPermission = await getPermissions();
    final userPermissions = await store.getPermissions();
    if (eventPermission.isEmpty || userPermissions!.isEmpty) {
      return false;
    } else {
      return hasCommonElement(eventPermission, userPermissions) ? true : false;
    }
  }

  @override
  Future<void> deleteEvent(String id) async {
    await eventStore.deleteEvent(id);
  }

  @override
  Future<void> cacheEvent(EventModel event) async {
    await eventStore.cacheEvent(event);
  }
}
