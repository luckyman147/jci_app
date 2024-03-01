import 'dart:convert';



import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/Home/data/model/events/EventModel.dart';



class EventStore{
  const EventStore._();
  static const String _CachedEventsKey= 'CachedEvents';
  static const String _CachedEventsOfTheWeekKey= 'CachedEventsOfTheWeek';
  static const String _CachedEventsOfTheMonthKey= 'CachedEventsOfTheMonth';
  static Future<void> cacheEvents(List<EventModel> events) async{
    final pref = await SharedPreferences.getInstance();
    List EventsModelToJson=events.map((e) => e.toJson()).toList();
    pref.setString(_CachedEventsKey, jsonEncode(EventsModelToJson));
  }

  static Future<void> cacheEventsOfTheWeek(List<EventModel> events) async{
    final pref = await SharedPreferences.getInstance();
    List EventsModelToJson=events.map((e) => e.toJson()).toList();
    pref.setString(_CachedEventsOfTheWeekKey, jsonEncode(EventsModelToJson));
  }
  static Future<void> cacheEventsOfTheMonth(List<EventModel> events) async{
    final pref = await SharedPreferences.getInstance();
    List EventsModelToJson=events.map((e) => e.toJson()).toList();
    pref.setString(_CachedEventsOfTheMonthKey, jsonEncode(EventsModelToJson));
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
  static Future<List<EventModel>> getCachedEventsOfTheWeek() async{
    final pref = await SharedPreferences.getInstance();
    final cachedEvents=pref.getString(_CachedEventsOfTheWeekKey);
    if(cachedEvents!=null){
      List<dynamic> eventsJson=jsonDecode(cachedEvents);
      return  eventsJson.map<EventModel>((e) => EventModel.fromJson(e)).toList();
    }
    return [];
  }
  static Future<List<EventModel>> getCachedEventsOfTheMonth() async{
    final pref = await SharedPreferences.getInstance();
    final cachedEvents=pref.getString(_CachedEventsOfTheMonthKey);
    if(cachedEvents!=null){
      List<dynamic> eventsJson=jsonDecode(cachedEvents);
      return  eventsJson.map<EventModel>((e) => EventModel.fromJson(e)).toList();
    }
    return [];
  }
}