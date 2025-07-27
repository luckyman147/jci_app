import 'dart:convert';
import 'dart:math';


import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/features/Home/data/model/CommentModel.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/Home/data/model/meetingModel/MeetingModel.dart';




class MeetingStore{

  static const _CachedMeetingsTimestampKey = 'CachedMeetingsTimestamp';
  static const  _CacheDurationInMinutes =30;
  static const String _CachedMeetingsKey= 'CachedMeetings';
  static const String _meetPermissionsKey= 'meetingsPermissions';
  static  String _MeetById(String id)=> 'meetingsPermissions/$id';
  static String _notesKey(String start,String limit)=> 'notes/$start/$limit';

  static const Duration cacheDuration = Duration(minutes: 30);


  static Future<void> cacheMeetings(List<MeetingModel> Meetings) async {
    final pref = await SharedPreferences.getInstance();
    List MeetingsModelToJson = Meetings.map((e) => e.toJson(isDecode: true)).toList();
Logger().d(MeetingsModelToJson);

    // Cache the Meetings and the current timestamp
    pref.setString(_CachedMeetingsKey, jsonEncode(MeetingsModelToJson));
    Logger().d(MeetingsModelToJson);    pref.setInt(
        _CachedMeetingsTimestampKey, DateTime.now().millisecondsSinceEpoch);

  }
  static Future<List<MeetingModel>> getCachedMeetings() async{
    final pref = await SharedPreferences.getInstance();

    // Check if the cache is still valid
    final timestamp = pref.getInt(_CachedMeetingsTimestampKey);
    if (timestamp != null && DateTime.now().millisecondsSinceEpoch - timestamp < cacheDuration.inMilliseconds) {
      // Cache is still valid
      final cachedEvents = pref.getString(_CachedMeetingsKey);
      if (cachedEvents != null) {
        List<dynamic> eventsJson = jsonDecode(cachedEvents);
        return eventsJson.map<MeetingModel>((e) => MeetingModel.fromJson(e, isDecode: true)).toList();
      }

  } return [];}

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

  static Future<void> deleteMeeting(String id)async {


    final  meetings=await getCachedMeetings();
    final index=meetings.indexWhere((element) => element.activityBasics.id==id);
    if(index!=-1){
      meetings.removeAt(index);
      await cacheMeetings(meetings);
    }
    else{
      throw NotFoundException();
    }

  }

  static Future<void> cacheMeeting(MeetingModel result)async {
    final meetings=await getCachedMeetings();
    meetings.add(result);
    await cacheMeetings(meetings);

  }
 static Future<void> cacheMeetingById(MeetingModel result)async {
    final pref = await SharedPreferences.getInstance();

    pref.setString(_MeetById(result.activityBasics.id), jsonEncode(result.toJson(isDecode: true)));

  }

  static Future<MeetingModel?> getCachedMeetingById(String id)async {
    final pref =  await SharedPreferences.getInstance();
    final cachedMeetings=pref.getString(_MeetById(id));
    if(cachedMeetings!=null){
      final meetingsJson=jsonDecode(cachedMeetings);
      return MeetingModel.fromJson(meetingsJson);
    }
    return null;

  }
}