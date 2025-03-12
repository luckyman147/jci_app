
import 'package:jci_app/core/config/services/store.dart';

class LanguageCacheHelper {
  Future<void> CacheLanguageCode(String languageCode) async {
   const Store().setLocaleLanguage(languageCode);
  }

  Future<String> getCachedLanguageCode() async {

    final cachedLanguageCode =await  const Store().getLocaleLanguage();
    if (cachedLanguageCode != null) {
      return cachedLanguageCode;
    }
    return "fr"; // default value
  }}