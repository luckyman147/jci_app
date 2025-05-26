import 'package:encrypt_shared_preferences/provider.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Store {
  final EncryptedSharedPreferences pref;
  Store(this.pref);
  final String _RefreshTokenKey = "refreshToken";
  final String _AccessTokenKey = "accessToken";
  final _PermissionsKey = "permissions";
  final String _FirstEntryKey = "firstEntry";
  final String _isLogged = "isLoggedIn";
  final String Otp = "Otp";
  final String status = "status";
  final String _email = "EmAiL";
  final String _roleKey = "role";
  final String UserId = "UserId";

  Future<void> setUserId(String id) async {
    await pref.setString(UserId, id);
  }

  Future<String?> getUserId() async {
    return pref.getString(UserId);
  }

  Future<void> setRole(DocumentReference role) async {
    await pref.setString(_roleKey, role.path);
  }

  Future<DocumentReference?> getRole() async {
    final path = await pref.getString(_roleKey);
    if (path == null) {
      return null;
    }
    return FirebaseFirestore.instance.doc(path);
  }

  Future<void> setRoleName(String role) async {
    await pref.setString(_roleKey, role);
  }

  Future<String?> getRoleName() async {
    return pref.getString(_roleKey);
  }

  Future<void> setTokens(String RefreshToke, String AccessToken) async {
    await pref.setString(_RefreshTokenKey, RefreshToke);
    await pref.setString(_AccessTokenKey, AccessToken);
  }

  Future<void> SetEmail(String email) async {
    await pref.setString(_email, email);
  }

  Future<String?> getPreviousEmail() async {
    return pref.getString(_email);
  }

  Future<void> setStatus(bool isLogged) async {
    await pref.setBool(status, isLogged);
  }

  Future<bool> getStatus() async {
    return pref.getBool(status) ?? false;
  }

  Future<void> setPermissions(List<String> permissions) async {
    await pref.setStringList(_PermissionsKey, permissions);
  }

  List<String>? getPermissions() {
    return pref.getStringList(_PermissionsKey);
  }

  Future<List<String?>> GetTokens() async {
    final refresh = await pref.getString(_RefreshTokenKey);

    final access = await pref.getString(_AccessTokenKey);

    return [refresh, access];
  }

  Future<void> setOtp(String otp) async {
    await pref.setString(Otp, otp);
  }

  Future<String?> getOtp() async {
    return pref.getString(Otp);
  }

  Future<void> clear() async {
    await pref.setString(_RefreshTokenKey, "");
    await pref.setString(_AccessTokenKey, "");
    await pref.setStringList(_PermissionsKey, []);
  }

  Future<String?> getLocaleLanguage() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('LOCALE');
  }

  Future<void> setLocaleLanguage(String locale) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('LOCALE', locale);
  }

  Future<void> setFirstEntry() async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool(_FirstEntryKey, true);
  }

  Future<bool> isFirstEntry() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(_FirstEntryKey) ?? false;
  }

  Future<void> setLoggedIn(bool isLogged) async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool(_isLogged, isLogged);
  }

  Future<bool> isLoggedIn() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(_isLogged) ?? false;
  }
}
