import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/config/locale/app_localizations_delegate.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(LocaleInitial());
}
// import 'package:bloc/bloc.dart';

// import 'package:meta/meta.dart';

class localeCubit extends Cubit<LocaleState> {
  final LanguageCacheHelper languageCacheHelper;
  localeCubit(this.languageCacheHelper) : super(LocaleInitial());
  Future<void> getSavedLanguage() async {
    final String cachedLanguageCode =
        await languageCacheHelper.getCachedLanguageCode();

    emit(ChangeLocalState(Locale(cachedLanguageCode)));
    //  emit (state.copyWith(languageCode: cachedLanguageCode,locale: Locale(cachedLanguageCode)));
  }

  Future<String?> cachedLanguageCode() async =>
      await languageCacheHelper.getCachedLanguageCode();

  Future<void> changeLanguage(String languageCode) async {
    await languageCacheHelper.CacheLanguageCode(languageCode);

    emit(ChangeLocalState(Locale(languageCode)));
  }
}
