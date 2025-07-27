import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:jci_app/features/Home/data/model/PVModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PvLocalDataSources {
  Future<List<PvModel>> getPVs(String activityId);
  Future<Unit> cachePVs(List<PvModel> pvs, String activityId);
  Future<Unit> deletePVs(String PVId);
}
class PVLocalDataSourcesImpl implements PvLocalDataSources {
  final SharedPreferences sharedPreferences;
  PVLocalDataSourcesImpl({required this.sharedPreferences});
  String key(String ActivityId) => "PVs/$ActivityId";
  final timeToLive = const Duration(minutes: 5);
  @override
  Future<Unit> cachePVs(List<PvModel> pvs, String activityId) async{
    final List<String> pvsString = jsonEncode(pvs.map((e) => e.toMap()).toList()).toString().split(",");
  await  sharedPreferences.setStringList(key(activityId), pvsString);
  await sharedPreferences.setString("${key(activityId)}_time", DateTime.now().add(timeToLive).toIso8601String());
    return Future.value(unit);
  }

  @override
  Future<Unit> deletePVs(String PVId)async {
    final List<PvModel> pvs = await getPVs(PVId);
    pvs.removeWhere((element) => element.id == PVId);
    await cachePVs(pvs, PVId);
    return Future.value(unit);
  }

  @override
  Future<List<PvModel>> getPVs(String activityId) async{
    final List<String> pvsString = sharedPreferences.getStringList(key(activityId))??[];
    final time= sharedPreferences.getString("${key(activityId)}_time");
    if(time==null || DateTime.parse(time).isBefore(DateTime.now())){
      return [];
    }
    return pvsString.map((e) => PvModel.fromMap(jsonDecode(e))).toList();
  }
}