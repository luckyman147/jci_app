part of 'activity_ofweek_bloc.dart';

@immutable
abstract class ActivityOfweekState {}

class ActivityOfweekInitial extends ActivityOfweekState {}
class ActivityOfTheWeekLoadingState extends ActivityOfweekState {}

class ActivityWeekLoaded extends ActivityOfweekState {
  final List<Activity> act;

  ActivityWeekLoaded({required this.act});
}

class ACtivityWeekError extends ActivityOfweekState {
  final String message;

  ACtivityWeekError({required this.message});}