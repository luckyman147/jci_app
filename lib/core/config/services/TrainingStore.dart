import 'dart:convert';


import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/Home/data/model/TrainingModel/TrainingModel.dart';




class TrainingStore{
  const TrainingStore._();
  static const String _CachedTrainingsKey= 'CachedTrainings';
  static const String _CachedTrainingsOfTheWeekKey= 'CachedTrainingsOfTheWeek';
  static const String _CachedTrainingsOfTheMonthKey= 'CachedTrainingsOfTheMonth';
  static Future<void> cacheTrainings(List<TrainingModel> Trainings) async{
    final pref = await SharedPreferences.getInstance();
    List TrainingsModelToJson=Trainings.map((e) => e.toJson()).toList();
    pref.setString(_CachedTrainingsKey, jsonEncode(TrainingsModelToJson));
  }
  static Future<void> cacheTrainingsOfTheWeek(List<TrainingModel> Trainings) async{
    final pref = await SharedPreferences.getInstance();
    List TrainingsModelToJson=Trainings.map((e) => e.toJson()).toList();
    pref.setString(_CachedTrainingsOfTheWeekKey, jsonEncode(TrainingsModelToJson));
  }
  static Future<void> cacheTrainingsOfTheMonth(List<TrainingModel> Trainings) async{
    final pref = await SharedPreferences.getInstance();
    List TrainingsModelToJson=Trainings.map((e) => e.toJson()).toList();
    pref.setString(_CachedTrainingsOfTheMonthKey, jsonEncode(TrainingsModelToJson));
  }
  static Future<List<TrainingModel>> getCachedTrainings() async{
    final pref = await SharedPreferences.getInstance();
    final cachedTrainings=pref.getString(_CachedTrainingsKey);
    if(cachedTrainings!=null){
      List<dynamic> TrainingsJson=jsonDecode(cachedTrainings);
      return  TrainingsJson.map<TrainingModel>((e) => TrainingModel.fromJson(e)).toList();
    }
    return [];
  }
  static Future<List<TrainingModel>> getCachedTrainingsOfTheWeek() async{
    final pref = await SharedPreferences.getInstance();
    final cachedTrainings=pref.getString(_CachedTrainingsOfTheWeekKey);
    if(cachedTrainings!=null){
      List<dynamic> TrainingsJson=jsonDecode(cachedTrainings);
      return  TrainingsJson.map<TrainingModel>((e) => TrainingModel.fromJson(e)).toList();
    }
    return [];
  }
  static Future<List<TrainingModel>> getCachedTrainingsOfTheMonth() async{
    final pref = await SharedPreferences.getInstance();
    final cachedTrainings=pref.getString(_CachedTrainingsOfTheMonthKey);
    if(cachedTrainings!=null){
      List<dynamic> TrainingsJson=jsonDecode(cachedTrainings);
      return  TrainingsJson.map<TrainingModel>((e) => TrainingModel.fromJson(e)).toList();
    }
    return [];
  }
}