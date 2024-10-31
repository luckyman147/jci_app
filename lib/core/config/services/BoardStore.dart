import 'dart:convert';

import 'package:jci_app/features/about_jci/data/models/BoardYearModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/about_jci/data/models/BoardRoleModel.dart';

class BoardStore {
  const BoardStore._();

  static const String getYears = 'Years';
static String getBoard(String year)=>"Board/$year";
static String getBoardRole(int Priority)=>"Board/$Priority";
static String isUpdated(int prio)=>"isUpdated/$prio";
static Future<List<String>> getCachedYears() async {
  final pref = await SharedPreferences.getInstance();
  return pref.getStringList(getYears) ?? [];
  }
  static Future<bool> getIsUpdated(int priority) async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(isUpdated(priority)) ?? true;
  }
  static Future<void> cacheIsUpdated(bool isbool,int prio) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(isUpdated(prio), isbool);
  }

  static Future<void> cacheYears(List<String> years) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setStringList(getYears, years);
  }

  static Future<void> cacheBoard(String year,BoardYearModel board)async {
    final pref = await SharedPreferences.getInstance();
    final boards= board.toJson();
    await pref.setString(getBoard(year), jsonEncode(boards));


  }
  static Future<BoardYearModel?> getBoards(String year)async{

    final pref = await SharedPreferences.getInstance();
    final cachedBoard=pref.getString(getBoard(year));
    if(cachedBoard!=null){
      dynamic boardJson=jsonDecode(cachedBoard);
      return BoardYearModel.fromJson(boardJson);
    }
    return null;

  }
  static Future<void> cacheBoardRoles(int priority,List<BoardRoleModel> roles)async{
    final pref = await SharedPreferences.getInstance();
    final boardRoles=roles.map((e) => e.toJson()).toList();
    await pref.setString(getBoardRole(priority), jsonEncode(boardRoles));
  }
  static Future<List<BoardRoleModel>> getBoardRoles(int priority)async{
    final pref = await SharedPreferences.getInstance();
    final cachedRoles=pref.getString(getBoardRole(priority));
    if(cachedRoles!=null){
      final List<dynamic> rolesJson=jsonDecode(cachedRoles);
      return rolesJson.map((e) => BoardRoleModel.fromJson(e)).toList();
    }
    return [];
  }
}