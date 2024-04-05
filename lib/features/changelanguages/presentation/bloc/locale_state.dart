part of 'locale_cubit.dart';

class LocaleState  extends Equatable{
  final Locale locale;
  final String languageCode;
  const LocaleState({this.locale=const Locale('en'),this.languageCode=""});
  LocaleState copyWith({Locale? locale,String? languageCode}) {
    return LocaleState(
      locale: locale ?? this.locale,
      languageCode: languageCode ?? this.languageCode,
    );
  }
  @override
   List<Object> get props => [locale,languageCode];

}

 class LocaleInitial extends LocaleState {}

class ChangeLocalState extends LocaleState {
  final Locale locale;
  ChangeLocalState(this.locale);
}
