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
//timestamp
  static const String _CachedTrainingsTimestampKey = 'CachedTrainingsTimestamp';
  static  String _CachedTrainingKey(String id) =>'CachedTraining/$id';


    static Future<void> cacheTrainings(List<TrainingModel> Trainings) async{
    final pref = await SharedPreferences.getInstance();
    List TrainingsModelToJson=Trainings.map((e) => e.toJson(isDecode: true)).toList();
    pref.setString(_CachedTrainingsKey, jsonEncode(TrainingsModelToJson));
    pref.setInt(
        _CachedTrainingsTimestampKey, DateTime.now().millisecondsSinceEpoch);
  }
  static Future<void> cacheTrainingsOfThemonth(List<TrainingModel> Trainings) async{
    final pref = await SharedPreferences.getInstance();
    List TrainingsModelToJson=Trainings.map((e) => e.toJson(isDecode: true)).toList();
    pref.setString(_CachedTrainingsOfTheMonthKey, jsonEncode(TrainingsModelToJson));
  }
  static Future<List<TrainingModel>> getCachedTrainingsOfTheMonth() async{
    final pref = await SharedPreferences.getInstance();
    final cachedTrainings=pref.getString(_CachedTrainingsOfTheMonthKey);
    if(cachedTrainings!=null){
      List<dynamic> TrainingsJson=jsonDecode(cachedTrainings);
      return  TrainingsJson.map<TrainingModel>((e) => TrainingModel.fromJson(e,isDecode: true)).toList();
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
    final cachedTimestamp = pref.getInt(_CachedTrainingsTimestampKey);
    if (cachedTrainings != null && cachedTimestamp != null) {
      // Check if the cache is still valid
      final cacheAge = DateTime.now().millisecondsSinceEpoch - cachedTimestamp;
      if (cacheAge < const Duration(minutes: 30).inMilliseconds) {
        // Return cached data if still valid
        List<dynamic> decodedJson = jsonDecode(cachedTrainings) ;
        return decodedJson.map((e) => TrainingModel.fromJson(e,isDecode: true)).toList();
      } else {
        // Cache expired, clear it
        await pref.remove(_CachedTrainingsKey);
        await pref.remove(_CachedTrainingsTimestampKey);
      }
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

  static Future<void> deleteTraining(String id)async {

    final Trainings = await getCachedTrainings();
    final newTrainings = Trainings.where((element) => element.activityBasics.id != id).toList();
    await cacheTrainings(newTrainings);
  }

  static   Future<void> cacheTraining(TrainingModel result) async{
    final Trainings = await getCachedTrainings();
    Trainings.add(result);
    await cacheTrainings(Trainings);

  }
  static   Future<void> cacheTrainingBYId(TrainingModel result) async{
    final pref=await SharedPreferences.getInstance();
    await pref.setString(_CachedTrainingKey(result.activityBasics.id), jsonEncode(result.toJson(isDecode: true)));

  }

  static Future<TrainingModel?> getCachedTrainingById(String id)async {
    final pref=await SharedPreferences.getInstance();
    final cachedTraining=pref.getString(_CachedTrainingKey(id));
    if(cachedTraining!=null){
      return TrainingModel.fromJson(jsonDecode(cachedTraining),isDecode: true);
    }
    return null;

  }
}