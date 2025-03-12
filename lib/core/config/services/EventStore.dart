import 'dart:convert';



import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/Home/data/model/events/EventModel.dart';



class EventStore {
  const EventStore._();
  static const String _CachedEventsKey = 'CachedEvents';
  static const String _eventPermissionsKey = 'eventPermissions';
  static const String _eventTimestampKey = 'eventTimestamp'; // Key for storing the timestamp
  static String _eventByIdKey(String id) => 'Event$id';

  static const Duration cacheDuration = Duration(minutes: 30); // Cache duration

  static Future<void> cacheEvents(List<EventModel> events) async {
    final pref = await SharedPreferences.getInstance();
    List eventsModelToJson = events.map((e) => e.toJson(isdecode: true)).toList();

    // Store events and current timestamp
    await pref.setString(_CachedEventsKey, jsonEncode(eventsModelToJson));
    await pref.setInt(_eventTimestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<void> cacheEventById(EventModel event) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(_eventByIdKey(event.id), jsonEncode(event.toJson(isdecode: true)));
  }

  static Future<EventModel?> getEventById(String id) async {
    final pref = await SharedPreferences.getInstance();
    final event = pref.getString(_eventByIdKey(id));
    if (event != null) {
      return EventModel.fromJson(jsonDecode(event), isDecode: true);
    }
    return null;
  }

  static Future<List<EventModel>> getCachedEvents() async {
    final pref = await SharedPreferences.getInstance();

    // Check if the cache is still valid
    final timestamp = pref.getInt(_eventTimestampKey);
    if (timestamp != null && DateTime.now().millisecondsSinceEpoch - timestamp < cacheDuration.inMilliseconds) {
      // Cache is still valid
      final cachedEvents = pref.getString(_CachedEventsKey);
      if (cachedEvents != null) {
        List<dynamic> eventsJson = jsonDecode(cachedEvents);
        return eventsJson.map<EventModel>((e) => EventModel.fromJson(e, isDecode: true)).toList();
      }
    }

    // Cache is expired or not available
    return [];
  }

  static Future<void> clearCache() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove(_CachedEventsKey);
    await pref.remove(_eventPermissionsKey);
    await pref.remove(_eventTimestampKey); // Clear the timestamp as well
  }

  static Future<void> saveEventPermissions(List<String> eventPermissions) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setStringList(_eventPermissionsKey, eventPermissions);
  }

  static Future<List<String>> getEventPermissions() async {
    final pref = await SharedPreferences.getInstance();
    final eventPermissions = pref.getStringList(_eventPermissionsKey);
    return eventPermissions ?? [];
  }

  static deleteEvent(String id) async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove(_eventByIdKey(id));
    final events = await getCachedEvents();
    final newEvents = events.where((element) => element.id != id).toList();
    await cacheEvents(newEvents);

  }

  static   Future<void> cacheEvent(EventModel event)async  {
    final pref = await SharedPreferences.getInstance();
    final events = await getCachedEvents();
    events.add(event);
    await cacheEvents(events);
  }



}