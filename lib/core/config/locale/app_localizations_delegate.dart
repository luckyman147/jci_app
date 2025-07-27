import 'package:jci_app/core/config/services/store.dart';

class LanguageCacheHelper {
  final Store store;

  LanguageCacheHelper({required this.store});
  Future<void> CacheLanguageCode(String languageCode) async {
    store.setLocaleLanguage(languageCode);
  }

  Future<String> getCachedLanguageCode() async {
    final cachedLanguageCode = await store.getLocaleLanguage();
    if (cachedLanguageCode != null) {
      return cachedLanguageCode;
    }
    return "fr"; // default value
  }
}
