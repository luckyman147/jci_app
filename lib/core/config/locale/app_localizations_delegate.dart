
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCacheHelper {
  Future<void> CacheLanguageCode(String languageCode) async {
    final sharedPreference = await SharedPreferences.getInstance();
    sharedPreference.setString('LOCALE', languageCode);
  }

  Future<String> getCachedLanguageCode() async {
    final sharedPreference = await SharedPreferences.getInstance();
    final cachedLanguageCode = sharedPreference.getString("LOCALE");
    if (cachedLanguageCode != null) {
      return cachedLanguageCode;
    }
    return "en"; // default value
  }}