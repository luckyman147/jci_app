import 'dart:convert';



import 'package:jci_app/features/Teams/data/models/TaskModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/Teams/data/models/TeamModel.dart';


enum CacheStatus{
  Public,Private
}
class TeamStore{
  const TeamStore._();
  static  String _CachedTeamsKey(CacheStatus cache)=> 'CachedTeams/${cache.toString()}';
  static const String _CachedTasksKey= 'CachedTasks';
  static const String _CachedboolKey= 'CachedUpdated';
 static  String _cachedTeamByid(String id) => 'CachedTeamByid$id';

  static Future<void> cacheTeams(List<TeamModel> Teams,CacheStatus cache) async{
    final pref = await SharedPreferences.getInstance();
    List TeamsModelToJson=Teams.map((e) => e.toJson()).toList();
    pref.setString(_CachedTeamsKey(cache), jsonEncode(TeamsModelToJson));
  }  static Future<void> cacheTasks(List<TaskModel> Teams) async{
    final pref = await SharedPreferences.getInstance();
    List tasksModelToJson=Teams.map((e) => e.toJson()).toList();
    pref.setString(_CachedTasksKey, jsonEncode(tasksModelToJson));
  }


  static Future<List<TeamModel>> getCachedTeams(CacheStatus cacheStatus) async{
    final pref = await SharedPreferences.getInstance();
    final cachedTeams=pref.getString(_CachedTeamsKey(cacheStatus));
    if(cachedTeams!=null){
      List<dynamic> TeamsJson=jsonDecode(cachedTeams);
      return  TeamsJson.map<TeamModel>((e) => TeamModel.fromJson(e)).toList();
    }
    return [];
  }
  static Future<List<TaskModel>> getCachedTasks() async{
    final pref = await SharedPreferences.getInstance();
    final cachedTasks=pref.getString(_CachedTasksKey);
    if(cachedTasks!=null){
      List<dynamic> TasksJson=jsonDecode(cachedTasks);
      return  TasksJson.map<TaskModel>((e) => TaskModel.fromJson(e)).toList();
    }
    return [];
  }


static Future<TeamModel?> getTeamByid(String id )async {
  final pref = await SharedPreferences.getInstance();
  final cachedTeams = pref.getString(_cachedTeamByid(id));
  if (cachedTeams != null) {
    Map<String, dynamic> TeamsJson = jsonDecode(cachedTeams);
    final team = TeamModel.fromJson(TeamsJson);
    return team;
  }
  return null;
}
//clear
static Future<void> clearCache() async {
  final pref = await SharedPreferences.getInstance();
  pref.remove(_CachedTeamsKey(CacheStatus.Private));
  pref.remove(_CachedTeamsKey(CacheStatus.Public));
}
static Future<void> cacheTeamByid(TeamModel team) async {
  final pref = await SharedPreferences.getInstance();
  pref.setString(_cachedTeamByid(team.id), jsonEncode(team.toJson()));
}

static Future<void> cacheUpdated(bool IsUpdated) async {
  final pref = await SharedPreferences.getInstance();
  pref.setBool(_CachedboolKey, IsUpdated);

}
static Future<bool> getUpdated() async {
  final pref = await SharedPreferences.getInstance();
  final cachedUpdated = pref.getBool(_CachedboolKey);
  if (cachedUpdated != null) {
    return cachedUpdated;
  }
  return false;
}
}