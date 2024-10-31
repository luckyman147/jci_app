
import 'package:secure_shared_preferences/secure_shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Store{
  const Store._();
  static const String _RefreshTokenKey="refreshToken";
  static const String _AccessTokenKey="accessToken";
  static const _PermissionsKey="permissions";
static const String _FirstEntryKey="firstEntry";
static const String _isLogged="isLoggedIn";
static const String Otp="Otp";
static const String status="status";

  static Future<void> setTokens(String RefreshToke,String AccessToken)async{
    final pref =await SecureSharedPref.getInstance();
    await pref.putString(_RefreshTokenKey, RefreshToke);
    await pref.putString(_AccessTokenKey, AccessToken);

  }
  static Future<void> setStatus(bool isLogged)async{
    final pref =await SharedPreferences.getInstance();
    await pref.setBool(status, isLogged);
  }

  static Future<bool> getStatus()async{
    final pref =await SharedPreferences.getInstance();
    return pref.getBool(status)??false;
  }
  static Future<void> setPermissions(List<String> permissions)async{
    final pref =await SecureSharedPref.getInstance();
    await pref.putStringList(_PermissionsKey, permissions);
  }
  static Future<List<String>> getPermissions()async{
    final pref =await SecureSharedPref.getInstance();
  return pref.getStringList(_PermissionsKey );
  }
  static Future<List<String?>> GetTokens()async{
    final pref =await SecureSharedPref.getInstance();
    final refresh=await pref.getString(_RefreshTokenKey);

    final access=await pref.getString(_AccessTokenKey);
    print([access,refresh]);
    return [refresh,access];
  }
static Future<void> setOtp(String otp)async {
  final pref = await SecureSharedPref.getInstance();
  await pref.putString(Otp, otp);
}
static Future<String?> getOtp()async {
  final pref = await SecureSharedPref.getInstance();
  return pref.getString(Otp);}
 static Future<void> clear() async{
   final pref =await SecureSharedPref.getInstance();
await pref.putString(_RefreshTokenKey, "");
await pref.putString(_AccessTokenKey, "");
await pref.putStringList(_PermissionsKey, []);

 }
 static Future<String?> getLocaleLanguage ()async {
   final pref =await SharedPreferences.getInstance();
   return  pref.getString('LOCALE');



 } static Future<void> setLocaleLanguage (String locale)async {
   final pref =await SharedPreferences.getInstance();
   pref.setString('LOCALE',locale);



 }
 static Future<void> setFirstEntry()async{
   final pref =await SharedPreferences.getInstance();
   pref.setBool(_FirstEntryKey,true);

 }
  static Future<bool> isFirstEntry()async{
    final pref =await SharedPreferences.getInstance();
    return pref.getBool(_FirstEntryKey)??false;
  }
  static Future<void> setLoggedIn(bool isLogged)async{
    final pref =await SharedPreferences.getInstance();
    pref.setBool(_isLogged,isLogged);

  }
  static Future<bool> isLoggedIn()async{
    final pref =await SharedPreferences.getInstance();
    return pref.getBool(_isLogged)??false;
  }

}
