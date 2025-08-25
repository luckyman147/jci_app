
part of 'acivity_f_bloc.dart';

class AcivityFState extends Equatable {
  final bool isLoading;
  final List<Activity>activities;
  final List<Activity>activitiesSearch;
final   List<Activity> activitiesOfMonth;
  final Activity? activityById;
final String? eventid;
  final String? errorMessage;
  final ActivityFetchState activityfetchState;

  const AcivityFState({
    this.activityfetchState = ActivityFetchState.Initial,
    this.isLoading = false,
    this.activities=const [],
    this.activitiesOfMonth=const [],
    this.activitiesSearch=const   [],
    this.activityById,
    this.eventid,

    this.errorMessage,
  });

  // Create a copyWith method to update state fields
  AcivityFState copyWith({
    ActivityFetchState? activityfetchState,
    bool? isLoading,
    String?eventid,
    List<Activity>? activities,
    List<Activity>? activitiesOfMonth,
    List<Activity>? activitiesSearch,
    Activity? activityById,
    List<Category>? categories,
    String? errorMessage,

  }) {
    return AcivityFState(
      activitiesOfMonth:  activitiesOfMonth ?? this.activitiesOfMonth,
      activityfetchState: activityfetchState ?? this.activityfetchState,
      isLoading: isLoading ?? this.isLoading,
      eventid: eventid??this.eventid,
      activities: activities ?? this.activities,
      activityById: activityById ?? this.activityById,
      activitiesSearch: activitiesSearch ?? this.activitiesSearch,

      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    activities,
    eventid,
    activityById,
    activitiesSearch,
    errorMessage,
    activityfetchState,
    activitiesOfMonth,
  ];
}
class AcivityFInitial extends AcivityFState {
  const AcivityFInitial();
}
