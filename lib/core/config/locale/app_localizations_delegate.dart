
import 'package:jci_app/core/config/services/store.dart';

class LanguageCacheHelper {
  Future<void> CacheLanguageCode(String languageCode) async {
   Store.setLocaleLanguage(languageCode);
  }

  Future<String> getCachedLanguageCode() async {

    final cachedLanguageCode =await  Store.getLocaleLanguage();
    if (cachedLanguageCode != null) {
      return cachedLanguageCode;
    }
    return "fr"; // default value
  }}