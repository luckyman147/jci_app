import 'dart:convert';



import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/Teams/data/models/TeamModel.dart';



class TeamStore{
  const TeamStore._();
  static const String _CachedTeamsKey= 'CachedTeams';

  static Future<void> cacheTeams(List<TeamModel> Teams) async{
    final pref = await SharedPreferences.getInstance();
    List TeamsModelToJson=Teams.map((e) => e.toJson()).toList();
    pref.setString(_CachedTeamsKey, jsonEncode(TeamsModelToJson));
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

}