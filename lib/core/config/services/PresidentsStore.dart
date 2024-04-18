import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/about_jci/data/models/PresidentModel.dart';

class PresidentStore {
  const PresidentStore._();

  static String  _pres_key(String start,String limit) => "president_key_$start$limit";
  static const String isUpdated="updated";

  static cachePresidents(List<PresidentModel> presidents,String start,String limit) {
    final List<String> encodedPresidents = presidents.map((president) =>
        json.encode(president.toJson())).toList();
    SharedPreferences.getInstance().then((prefs) =>
        prefs.setStringList(_pres_key(start,limit), encodedPresidents));
  }

  static Future<List<PresidentModel>> getCachedPresidents(String start,String limit) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedPresidents = prefs.getStringList(_pres_key(start,limit));
    if (cachedPresidents != null) {
      return cachedPresidents.map((president) =>
          PresidentModel.fromJson(json.decode(president))).toList();
    }
    return [];
  }

  static Future<void> setUpdated(bool updated) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(isUpdated, updated);
  }

  static Future<bool> getUpdated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isUpdated) ?? true;
  }
}