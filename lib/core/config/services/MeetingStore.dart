import 'dart:convert';


import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/Home/data/model/meetingModel/MeetingModel.dart';




class MeetingStore{
  const MeetingStore._();
  static const String _CachedMeetingsKey= 'CachedMeetings';
  static const String _CachedMeetingsOfTheWeekKey= 'CachedMeetingsOfTheWeek';
  static const String _CachedMeetingsOfTheMonthKey= 'CachedMeetingsOfTheMonth';
  static Future<void> cacheMeetings(List<MeetingModel> Meetings) async{
    final pref = await SharedPreferences.getInstance();
    List MeetingsModelToJson=Meetings.map((e) => e.toJson()).toList();
    pref.setString(_CachedMeetingsKey, jsonEncode(MeetingsModelToJson));
  }
  static Future<void> cacheMeetingsOfTheWeek(List<MeetingModel> Meetings) async{
    final pref = await SharedPreferences.getInstance();
    List MeetingsModelToJson=Meetings.map((e) => e.toJson()).toList();
    pref.setString(_CachedMeetingsOfTheWeekKey, jsonEncode(MeetingsModelToJson));
  }
  static Future<void> cacheMeetingsOfTheMonth(List<MeetingModel> Meetings) async{
    final pref = await SharedPreferences.getInstance();
    List MeetingsModelToJson=Meetings.map((e) => e.toJson()).toList();
    pref.setString(_CachedMeetingsOfTheMonthKey, jsonEncode(MeetingsModelToJson));
  }
  static Future<List<MeetingModel>> getCachedMeetings() async{
    final pref = await SharedPreferences.getInstance();
    final cachedMeetings=pref.getString(_CachedMeetingsKey);
    if(cachedMeetings!=null){
      List<dynamic> MeetingsJson=jsonDecode(cachedMeetings);
      return  MeetingsJson.map<MeetingModel>((e) => MeetingModel.fromJson(e)).toList();
    }
    return [];
  }
  static Future<List<MeetingModel>> getCachedMeetingsOfTheWeek() async{
    final pref = await SharedPreferences.getInstance();
    final cachedMeetings=pref.getString(_CachedMeetingsOfTheWeekKey);
    if(cachedMeetings!=null){
      List<dynamic> MeetingsJson=jsonDecode(cachedMeetings);
      return  MeetingsJson.map<MeetingModel>((e) => MeetingModel.fromJson(e)).toList();
    }
    return [];
  }
  static Future<List<MeetingModel>> getCachedMeetingsOfTheMonth() async{
    final pref = await SharedPreferences.getInstance();
    final cachedMeetings=pref.getString(_CachedMeetingsOfTheMonthKey);
    if(cachedMeetings!=null){
      List<dynamic> MeetingsJson=jsonDecode(cachedMeetings);
      return  MeetingsJson.map<MeetingModel>((e) => MeetingModel.fromJson(e)).toList();
    }
    return [];
  }
}