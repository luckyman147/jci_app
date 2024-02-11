part of 'locale_cubit.dart';

@immutable
sealed class LocaleState {}

final class LocaleInitial extends LocaleState {}

class ChangeLocalState extends LocaleState {
  final Locale locale;
  ChangeLocalState(this.locale);
}
