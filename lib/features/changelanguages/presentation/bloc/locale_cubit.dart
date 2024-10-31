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
  localeCubit() : super(LocaleInitial());
  Future<void> getSavedLanguage() async {
    final String cachedLanguageCode =
    await LanguageCacheHelper().getCachedLanguageCode();

    emit(ChangeLocalState(Locale(cachedLanguageCode)));
 //   emit (state.copyWith(languageCode: cachedLanguageCode,locale: Locale(cachedLanguageCode)));
  }
   Future<String?> cachedLanguageCode() async=> await LanguageCacheHelper().getCachedLanguageCode();

  Future<void> changeLanguage(String languageCode) async {
    await LanguageCacheHelper().CacheLanguageCode(languageCode);

    emit(ChangeLocalState(Locale(languageCode)));
  }
}
