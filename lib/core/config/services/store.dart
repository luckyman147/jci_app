
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Store{
  const Store();
final String _RefreshTokenKey="refreshToken";
  final String _AccessTokenKey="accessToken";
final _PermissionsKey="permissions";
 final String _FirstEntryKey="firstEntry";
 final String _isLogged="isLoggedIn";
final String Otp="Otp";
 final String status="status";
 final String _email="EmAiL";
 final String _roleKey="role";
 final String UserId="UserId";

Future<void> setUserId(String id)async{
  final pref =await SecureSharedPref.getInstance();
  await pref.putString(UserId, id);
}
Future<String?> getUserId()async{
  final pref =await SecureSharedPref.getInstance();
  return pref.getString(UserId);
}

Future<void> setRole(DocumentReference role)async{
  final pref =await SecureSharedPref.getInstance();
  await pref.putString(_roleKey, role.path);
}
Future<DocumentReference?> getRole()async{
  final pref =await SecureSharedPref.getInstance();
  final path=await pref.getString(_roleKey);
  if(path==null){
    return null;
  }
  return FirebaseFirestore.instance.doc(path);
}
   Future<void> setRoleName(String role)async{
    final pref =await SecureSharedPref.getInstance();
    await pref.putString(_roleKey, role);
  }
   Future<String?> getRoleName()async{
    final pref =await SecureSharedPref.getInstance();
    return pref.getString(_roleKey);
}
   Future<void> setTokens(String RefreshToke,String AccessToken)async{
    final pref =await SecureSharedPref.getInstance();
    await pref.putString(_RefreshTokenKey, RefreshToke);
    await pref.putString(_AccessTokenKey, AccessToken);

  }  Future<void> SetEmail(String email)async{
    final pref =await SecureSharedPref.getInstance();
    await pref.putString(_email, email);


  } Future<String?> getPreviousEmail( )async{
    final pref =await SecureSharedPref.getInstance();
  return    pref.getString(_email);


  }

   Future<void> setStatus(bool isLogged)async{
    final pref =await SharedPreferences.getInstance();
    await pref.setBool(status, isLogged);
  }

   Future<bool> getStatus()async{
    final pref =await SharedPreferences.getInstance();
    return pref.getBool(status)??false;
  }
   Future<void> setPermissions(List<String> permissions)async{
    final pref =await SecureSharedPref.getInstance();
    await pref.putStringList(_PermissionsKey, permissions);
  }
   Future<List<String>> getPermissions()async{
    final pref =await SecureSharedPref.getInstance();
  return pref.getStringList(_PermissionsKey );
  }
   Future<List<String?>> GetTokens()async{
    final pref =await SecureSharedPref.getInstance();
    final refresh=await pref.getString(_RefreshTokenKey);

    final access=await pref.getString(_AccessTokenKey);

    return [refresh,access];
  }
 Future<void> setOtp(String otp)async {
  final pref = await SecureSharedPref.getInstance();
  await pref.putString(Otp, otp);
}
 Future<String?> getOtp()async {
  final pref = await SecureSharedPref.getInstance();
  return pref.getString(Otp);}
  Future<void> clear() async{
   final pref =await SecureSharedPref.getInstance();
await pref.putString(_RefreshTokenKey, "");
await pref.putString(_AccessTokenKey, "");
await pref.putStringList(_PermissionsKey, []);

 }
  Future<String?> getLocaleLanguage ()async {
   final pref =await SharedPreferences.getInstance();
   return  pref.getString('LOCALE');



 }  Future<void> setLocaleLanguage (String locale)async {
   final pref =await SharedPreferences.getInstance();
   pref.setString('LOCALE',locale);



 }
  Future<void> setFirstEntry()async{
   final pref =await SharedPreferences.getInstance();
   pref.setBool(_FirstEntryKey,true);

 }
   Future<bool> isFirstEntry()async{
    final pref =await SharedPreferences.getInstance();
    return pref.getBool(_FirstEntryKey)??false;
  }
   Future<void> setLoggedIn(bool isLogged)async{
    final pref =await SharedPreferences.getInstance();
    pref.setBool(_isLogged,isLogged);

  }
   Future<bool> isLoggedIn()async{
    final pref =await SharedPreferences.getInstance();
    return pref.getBool(_isLogged)??false;
  }

}
