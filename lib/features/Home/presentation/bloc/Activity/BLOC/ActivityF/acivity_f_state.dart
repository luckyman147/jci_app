
part of 'acivity_f_bloc.dart';

class AcivityFState extends Equatable {
  final bool isLoading;
  final List<Activity>activities;
  final List<Activity>activitiesSearch;

  final Activity? activityById;

  final String? errorMessage;
  final ActivityFetchState activityfetchState;

  const AcivityFState({
    this.activityfetchState = ActivityFetchState.Initial,
    this.isLoading = false,
    this.activities=const [],
    this.activitiesSearch=const   [],
    this.activityById,

    this.errorMessage,
  });

  // Create a copyWith method to update state fields
  AcivityFState copyWith({
    ActivityFetchState? activityfetchState,
    bool? isLoading,
    List<Activity>? activities,
    List<Activity>? activitiesSearch,
    Activity? activityById,
    List<Category>? categories,
    String? errorMessage,

  }) {
    return AcivityFState(
      activityfetchState: activityfetchState ?? this.activityfetchState,
      isLoading: isLoading ?? this.isLoading,
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
    activityById,
    activitiesSearch,
    errorMessage,
    activityfetchState,
  ];
}
class AcivityFInitial extends AcivityFState {
  const AcivityFInitial();
}
