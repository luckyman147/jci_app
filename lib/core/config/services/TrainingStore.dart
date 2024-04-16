import 'dart:convert';


import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/Home/data/model/TrainingModel/TrainingModel.dart';




class TrainingStore{
  const TrainingStore._();
  static const String _CachedTrainingsKey= 'CachedTrainings';
  static const String _trainPermissions= 'trainingsPermissions';
    static Future<void> cacheTrainings(List<TrainingModel> Trainings) async{
    final pref = await SharedPreferences.getInstance();
    List TrainingsModelToJson=Trainings.map((e) => e.toJson()).toList();
    pref.setString(_CachedTrainingsKey, jsonEncode(TrainingsModelToJson));
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
  static Future<void> savetrainPermissions(List<String> eventPermissions) async{
    final pref = await SharedPreferences.getInstance();
    pref.setStringList(_trainPermissions, eventPermissions);
  }
  static Future<List<String>> getTrainPer() async{
    final pref = await SharedPreferences.getInstance();
    final eventPermissions=pref.getStringList(_trainPermissions);
    if(eventPermissions!=null){
      return eventPermissions;
    }
    return [];
  }
}