import 'dart:convert';


import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/Home/data/model/meetingModel/MeetingModel.dart';




class MeetingStore{
  const MeetingStore._();
  static const String _CachedMeetingsKey= 'CachedMeetings';
  static const String _meetPermissionsKey= 'meetingsPermissions';

  static Future<void> cacheMeetings(List<MeetingModel> Meetings) async {
    final pref = await SharedPreferences.getInstance();
    List MeetingsModelToJson = Meetings.map((e) => e.toJson()).toList();
    pref.setString(_CachedMeetingsKey, jsonEncode(MeetingsModelToJson));
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

  static Future<void> savemeetPermissions(List<String> eventPermissions) async{
    final pref = await SharedPreferences.getInstance();
    pref.setStringList(_meetPermissionsKey, eventPermissions);
  }
  static Future<List<String>> getmeetPermissions() async{
    final pref = await SharedPreferences.getInstance();
    final eventPermissions=pref.getStringList(_meetPermissionsKey);
    if(eventPermissions!=null){
      return eventPermissions;
    }
    return [];
  }
}