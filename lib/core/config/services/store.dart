import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jci_app/features/auth/data/models/AuthModel/AuthModel.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Store{
  const Store._();
  static const String _RefreshTokenKey="refreshToken";
  static const String _AccessTokenKey="accessToken";

  static const String  _UserInfo = 'UserInfo';
  static Future<void> setTokens(String RefreshToke,String AccessToken)async{
    final pref =await SecureSharedPref.getInstance();
    await pref.putString(_RefreshTokenKey, RefreshToke);
    await pref.putString(_AccessTokenKey, AccessToken);
  print(pref.getString(_RefreshTokenKey));
  }
  static Future<List<String?>> GetTokens()async{
    final pref =await SecureSharedPref.getInstance();
    final refresh=await pref.getString(_RefreshTokenKey);

    final access=await pref.getString(_AccessTokenKey);
    print([access,refresh]);
    return [refresh,access];
  }


 static Future<void> clear() async{
   final pref =await SecureSharedPref.getInstance();
await pref.putString(_RefreshTokenKey, "");
await pref.putString(_AccessTokenKey, "");
await pref.putString(_UserInfo, "");
 }
 static Future<String?> getLocaleLanguage ()async {
   final pref =await SharedPreferences.getInstance();
   return  pref.getString('LOCALE');



 } static Future<void> setLocaleLanguage (String locale)async {
   final pref =await SharedPreferences.getInstance();
   pref.setString('LOCALE',locale);



 }
 static Future<void> saveModel(modelAuth auth) async {
    final prefs = await SecureSharedPref.getInstance();
    final key = 'UserInfo';
    final value = auth.toJson();

    prefs.putString(key, jsonEncode(value));
  }
  static Future<modelAuth?> getModel() async {
    final prefs = await SecureSharedPref.getInstance();

    final value = await  prefs.getString(_UserInfo);

    if (value == null) {
      return null;
    }
    if (value.isEmpty) {
      return null;
    }

    return modelAuth.fromJson(jsonDecode(value));
  }
}
