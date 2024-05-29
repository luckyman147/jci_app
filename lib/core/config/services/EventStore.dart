import 'dart:convert';



import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/Home/data/model/events/EventModel.dart';



class EventStore{
  const EventStore._();
  static const String _CachedEventsKey= 'CachedEvents';
  static const String _eventPermissionsKey= 'eventPermissions';
  static String _eventBYidKey(String id)=> 'Event$id';

  static Future<void> cacheEvents(List<EventModel> events) async{
    final pref = await SharedPreferences.getInstance();
    List EventsModelToJson=events.map((e) => e.toJson()).toList();
    pref.setString(_CachedEventsKey, jsonEncode(EventsModelToJson));
  }
  static Future<void> cacheEventById(EventModel event) async{
    final pref = await SharedPreferences.getInstance();
    pref.setString(_eventBYidKey(event.id), jsonEncode(event.toJson()));
  }
  static Future<EventModel?> getEventById(String id) async{
    final pref = await SharedPreferences.getInstance();
    final event=pref.getString(_eventBYidKey(id));
    if(event!=null){
      return EventModel.fromJson(jsonDecode(event));
    }
    return null;
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