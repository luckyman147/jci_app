import 'dart:convert';



import 'package:dartz/dartz.dart';
import 'package:jci_app/features/Teams/data/models/TaskModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/Teams/data/models/TeamModel.dart';



class TeamStore{
  const TeamStore._();
  static const String _CachedTeamsKey= 'CachedTeams';
  static const String _CachedTasksKey= 'CachedTasks';

  static Future<void> cacheTeams(List<TeamModel> Teams) async{
    final pref = await SharedPreferences.getInstance();
    List TeamsModelToJson=Teams.map((e) => e.toJson()).toList();
    pref.setString(_CachedTeamsKey, jsonEncode(TeamsModelToJson));
  }  static Future<void> cacheTasks(List<TaskModel> Teams) async{
    final pref = await SharedPreferences.getInstance();
    List tasksModelToJson=Teams.map((e) => e.toJson()).toList();
    pref.setString(_CachedTasksKey, jsonEncode(tasksModelToJson));
  }


  static Future<List<TeamModel>> getCachedTeams() async{
    final pref = await SharedPreferences.getInstance();
    final cachedTeams=pref.getString(_CachedTeamsKey);
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


}