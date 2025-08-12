import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

class Store {
  final Box box = Hive.box('secureBox');

  final String _refreshTokenKey = "refreshToken";
  final String _accessTokenKey = "accessToken";
  final String _permissionsKey = "permissions";
  final String _firstEntryKey = "firstEntry";
  final String _isLoggedKey = "isLoggedIn";
  final String _otpKey = "Otp";
  final String _statusKey = "status";
  final String _emailKey = "email";
  final String _roleKey = "role";
  final String _userIdKey = "UserId";
  final String _localeKey = "LOCALE";

  // Tokens
  Future<void> setTokens(String refreshToken, String accessToken) async {
    await box.put(_refreshTokenKey, refreshToken);
    await box.put(_accessTokenKey, accessToken);
  }

  List<String?> getTokens() {
    final refresh = box.get(_refreshTokenKey);
    final access = box.get(_accessTokenKey);
    return [refresh, access];
  }

  // Email
  Future<void> setEmail(String email) async {
    await box.put(_emailKey, email);
  }

  String? getEmail() => box.get(_emailKey);

  // OTP
  Future<void> setOtp(String otp) async {
    await box.put(_otpKey, otp);
  }

  String? getOtp() => box.get(_otpKey);

  // User ID
  Future<void> setUserId(String id) async {
    await box.put(_userIdKey, id);
  }

  String? getUserId() => box.get(_userIdKey);

  // Role (store path as string)
  Future<void> setRole(DocumentReference role) async {
    await box.put(_roleKey, role.path);
  }

  DocumentReference? getRole() {
    final path = box.get(_roleKey);
    if (path == null) return null;
    return FirebaseFirestore.instance.doc(path);
  }

  Future<void> setRoleName(String roleName) async {
    await box.put(_roleKey, roleName);
  }

  String? getRoleName() => box.get(_roleKey);

  // Permissions
  Future<void> setPermissions(List<String> permissions) async {
    await box.put(_permissionsKey, permissions);
  }

  List<String> getPermissions() {
    return (box.get(_permissionsKey) as List?)?.cast<String>() ?? [];
  }

  // First Entry
  Future<void> setFirstEntry() async {
    await box.put(_firstEntryKey, true);
  }

  bool isFirstEntry() {
    return box.get(_firstEntryKey, defaultValue: false);
  }

  // Logged In
  Future<void> setLoggedIn(bool isLogged) async {
    await box.put(_isLoggedKey, isLogged);
  }

  bool isLoggedIn() {
    return box.get(_isLoggedKey, defaultValue: false);
  }

  // Status
  Future<void> setStatus(bool status) async {
    await box.put(_statusKey, status);
  }

  bool getStatus() {
    return box.get(_statusKey, defaultValue: false);
  }

  // Locale
  Future<void> setLocaleLanguage(String locale) async {
    await box.put(_localeKey, locale);
  }

  String? getLocaleLanguage() => box.get(_localeKey);

  // Clear all
  Future<void> clear() async {
    await box.clear();
  }
}
