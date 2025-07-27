import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../../../features/Home/data/model/events/EventModel.dart';
import '../../../features/auth/AuthWidgetGlobal.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../features/Home/data/model/events/EventModel.dart';
import '../../../features/auth/AuthWidgetGlobal.dart';

class EventStore {
  static const String _CachedEventsKey = 'CachedEvents';
  static const String _eventPermissionsKey = 'eventPermissions';
  static const String _eventTimestampKey = 'eventTimestamp';
  static const String _pinnedEventsKey = 'PinnedEvents';
  static const Duration cacheDuration = Duration(seconds: 1);

  static String _eventByIdKey(String id) => 'Event$id';

  final SharedPreferences _prefs;

  /// ✅ Private constructor
  EventStore._(this._prefs);

  /// ✅ Async factory constructor
  static Future<EventStore> create() async {
    final prefs = await SharedPreferences.getInstance();
    return EventStore._(prefs);
  }

  // ----- PINNED EVENTS -----
  Future<void> pinEvent(String eventId) async {
    final pinnedEvents = _prefs.getStringList(_pinnedEventsKey) ?? [];
    if (!pinnedEvents.contains(eventId)) {
      pinnedEvents.add(eventId);
      await _prefs.setStringList(_pinnedEventsKey, pinnedEvents);
    }
  }

  Future<List<EventModel>> getPinnedEvents() async {
    final pinnedIds = _prefs.getStringList(_pinnedEventsKey) ?? [];
    final pinnedEvents = <EventModel>[];
    for (final id in pinnedIds) {
      final event = await getEventById(id);
      if (event != null) pinnedEvents.add(event);
    }
    return pinnedEvents;
  }

  Future<void> unpinEvent(String eventId) async {
    final pinnedEvents = _prefs.getStringList(_pinnedEventsKey) ?? [];
    pinnedEvents.remove(eventId);
    await _prefs.setStringList(_pinnedEventsKey, pinnedEvents);
  }

  Future<bool> isPinned(String eventId) async {
    final pinnedEvents = _prefs.getStringList(_pinnedEventsKey) ?? [];
    return pinnedEvents.contains(eventId);
  }

  // ----- EVENT CACHE -----
  Future<void> cacheEvents(List<EventModel> events) async {
    final jsonList = events.map((e) => e.toJson()).toList();
    await _prefs.setString(_CachedEventsKey, jsonEncode(jsonList));
    await _prefs.setInt(_eventTimestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> cacheEventById(EventModel event) async {
    Logger().i(event.activityBasics.id);
    Logger().i(event.toJson());
    await _prefs.setString(_eventByIdKey(event.activityBasics.id), jsonEncode(event.toJson()));
  }

  Future<EventModel?> getEventById(String id) async {
    Logger().i(id);
    final event = _prefs.getString(_eventByIdKey(id));
    Logger().i(event);
    if (event != null) {
      return EventModel.fromJson(jsonDecode(event), isDecode: true);
    }
    return null;
  }

  Future<List<EventModel>> getCachedEvents() async {
    final timestamp = _prefs.getInt(_eventTimestampKey);
    if (timestamp != null &&
        DateTime.now().millisecondsSinceEpoch - timestamp < cacheDuration.inMilliseconds) {
      final cachedEvents = _prefs.getString(_CachedEventsKey);
      if (cachedEvents != null) {
        final jsonList = jsonDecode(cachedEvents);
        return (jsonList as List)
            .map((e) => EventModel.fromJson(e, isDecode: true))
            .toList();
      }
    }
    return [];
  }

  Future<void> clearCache() async {
    await _prefs.remove(_CachedEventsKey);
    await _prefs.remove(_eventPermissionsKey);
    await _prefs.remove(_eventTimestampKey);
  }

  Future<void> saveEventPermissions(List<String> eventPermissions) async {
    await _prefs.setStringList(_eventPermissionsKey, eventPermissions);
  }

  Future<List<String>> getEventPermissions() async {
    return _prefs.getStringList(_eventPermissionsKey) ?? [];
  }

  Future<void> deleteEvent(String id) async {
    await _prefs.remove(_eventByIdKey(id));
    final events = await getCachedEvents();
    final newEvents = events.where((e) => e.activityBasics.id != id).toList();
    await cacheEvents(newEvents);
  }

  Future<void> cacheEvent(EventModel event) async {
    final events = await getCachedEvents();
    events.add(event);
    await cacheEvents(events);
  }
}
