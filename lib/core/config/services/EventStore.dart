import 'dart:convert';



import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/Home/data/model/events/EventModel.dart';



class EventStore{
  const EventStore._();
  static const String _CachedEventsKey= 'CachedEvents';
  static const String _eventPermissionsKey= 'eventPermissions';
  static const String _CachedEventsOfTheWeekKey= 'CachedEventsOfTheWeek';
  static const String _CachedEventsOfTheMonthKey= 'CachedEventsOfTheMonth';
  static Future<void> cacheEvents(List<EventModel> events) async{
    final pref = await SharedPreferences.getInstance();
    List EventsModelToJson=events.map((e) => e.toJson()).toList();
    pref.setString(_CachedEventsKey, jsonEncode(EventsModelToJson));
  }


  static Future<List<EventModel>> getCachedEvents() async{
    final pref = await SharedPreferences.getInstance();
    final cachedEvents=pref.getString(_CachedEventsKey);
    if(cachedEvents!=null){
      List<dynamic> eventsJson=jsonDecode(cachedEvents);
     return  eventsJson.map<EventModel>((e) => EventModel.fromJson(e)).toList();
    }
    return [];
  }
  static Future<void> clearCache() async{
    final pref = await SharedPreferences.getInstance();
    pref.remove(_CachedEventsKey);
    pref.remove(_eventPermissionsKey);
  }
  static Future<void> saveEventPermissions(List<String> eventPermissions) async{
    final pref = await SharedPreferences.getInstance();
    pref.setStringList(_eventPermissionsKey, eventPermissions);
  }
  static Future<List<String>> getEventPermissions() async{
    final pref = await SharedPreferences.getInstance();
    final eventPermissions=pref.getStringList(_eventPermissionsKey);
    if(eventPermissions!=null){
      return eventPermissions;
    }
    return [];
  }

}