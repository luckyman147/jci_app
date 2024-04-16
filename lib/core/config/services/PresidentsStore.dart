import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/about_jci/data/models/PresidentModel.dart';

class PresidentStore {
  const PresidentStore._();

  static const _pres_key = "president_key";

  static cachePresidents(List<PresidentModel> presidents) {
    final List<String> encodedPresidents = presidents.map((president) =>
        json.encode(president.toJson())).toList();
    SharedPreferences.getInstance().then((prefs) =>
        prefs.setStringList(_pres_key, encodedPresidents));
  }

  static Future<List<PresidentModel>> getCachedPresidents() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedPresidents = prefs.getStringList(_pres_key);
    if (cachedPresidents != null) {
      return cachedPresidents.map((president) =>
          PresidentModel.fromJson(json.decode(president))).toList();
    }
    return [];
  }
}