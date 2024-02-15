import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Store{
  const Store._();
  static const String _RefreshTokenKey="refreshToken";
  static const String _AccessTokenKey="accessToken";
  static Future<void> setTokens(String RefreshToke,String AccessToken)async{
    final pref =await SharedPreferences.getInstance();
    await pref.setString(_RefreshTokenKey, RefreshToke);
    await pref.setString(_AccessTokenKey, AccessToken);
  print(pref.getString(_RefreshTokenKey));
  }
  static Future<List<String?>> GetTokens()async{
    final pref =await SharedPreferences.getInstance();
    final refresh=await pref.getString(_RefreshTokenKey);

    final access=await pref.getString(_AccessTokenKey);
    print([access,refresh]);
    return [refresh,access];
  }
  static Future<String?> getPathInitial() async{
    final pref =const FlutterSecureStorage();

    final path=pref.read(key: '/path');
    if (path!=null) {
      return path;
    }
    else{
      return "/";
    }
  }
  static Future<void> setPath(String path)async{
    final pref =const FlutterSecureStorage();
 pref.write(key: "/path", value: path);
  }
 static Future<void> clear() async{
   final pref =await SharedPreferences.getInstance();
await pref .clear();
 }
 static Future<String?> getLocaleLanguage ()async {
   final pref =await SharedPreferences.getInstance();
   return  pref.getString('LOCALE');



 } static Future<void> setLocaleLanguage (String locale)async {
   final pref =await SharedPreferences.getInstance();
   pref.setString('LOCALE',locale);



 }
}