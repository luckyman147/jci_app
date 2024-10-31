import 'dart:convert';


import 'package:jci_app/features/Home/data/model/GuestModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/Home/data/model/TrainingModel/TrainingModel.dart';




class TrainingStore{
  const TrainingStore._();
  static const String _CachedTrainingsKey= 'CachedTrainings';
  static const String _trainPermissions= 'trainingsPermissions';
  static const String _GuestsKey='GuestKey';
static const String _CachedTrainingsOfTheMonthKey='CachedTrainingsOfThemonth';
    static Future<void> cacheTrainings(List<TrainingModel> Trainings) async{
    final pref = await SharedPreferences.getInstance();
    List TrainingsModelToJson=Trainings.map((e) => e.toJson()).toList();
    pref.setString(_CachedTrainingsKey, jsonEncode(TrainingsModelToJson));
  }
  static Future<void> cacheTrainingsOfThemonth(List<TrainingModel> Trainings) async{
    final pref = await SharedPreferences.getInstance();
    List TrainingsModelToJson=Trainings.map((e) => e.toJson()).toList();
    pref.setString(_CachedTrainingsOfTheMonthKey, jsonEncode(TrainingsModelToJson));
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

  // cache guest
  static Future<void> cacheGuests(List<GuestModel> guests) async{
    final pref = await SharedPreferences.getInstance();
    List TrainingsModelToJson=guests.map((e) => e.toJson()).toList();
    pref.setString(_GuestsKey, jsonEncode(TrainingsModelToJson));
  }
  static Future<List<GuestModel>> getGuests() async{
    final pref = await SharedPreferences.getInstance();
    final cachedTrainings=pref.getString(_GuestsKey);
    if(cachedTrainings!=null){
      List<dynamic> TrainingsJson=jsonDecode(cachedTrainings);
      return  TrainingsJson.map<GuestModel>((e) => GuestModel.fromJson(e)).toList();
    }
    return [];
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