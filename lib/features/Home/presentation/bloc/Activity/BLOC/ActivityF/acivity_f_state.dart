part of 'acivity_f_bloc.dart';

abstract class AcivityFState extends Equatable {
  const AcivityFState();
}

class AcivityFInitial extends AcivityFState {
  @override
  List<Object> get props => [];
}
class ActivityLoadingState extends AcivityFState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class ActivityLoadedState extends AcivityFState  {
  final List<Activity> activitys;
  const ActivityLoadedState({required this.activitys});
  @override
  List<Object> get props => [activitys];
}class ActivityLoadedMonthState extends AcivityFState  {
  final List<Activity> activitys;
  const ActivityLoadedMonthState({required this.activitys});
  @override
  List<Object> get props => [activitys];
}
class ACtivityByIdLoadedState extends AcivityFState  {
  final Activity activity;
  const ACtivityByIdLoadedState({required this.activity});
  @override
  List<Object> get props => [activity];
}
class ErrorActivityState extends AcivityFState {
  final String message;
  const ErrorActivityState({required this.message});
  @override
  List<Object> get props => [message];
}


class SearchLoading extends AcivityFState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SearchLoaded extends AcivityFState {
  final List<Category> categories;

  const SearchLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class SearchError extends AcivityFState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}