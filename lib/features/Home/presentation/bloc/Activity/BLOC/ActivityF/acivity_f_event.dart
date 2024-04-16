part of 'acivity_f_bloc.dart';

abstract class AcivityFEvent extends Equatable {
  const AcivityFEvent();
}

class RefreshActivities extends AcivityFEvent {
  final activity act;

  const RefreshActivities({required this.act});
  @override
  List<Object> get props => [];
}
class GetAllActivitiesEvent extends AcivityFEvent {
  final activity act;

  const GetAllActivitiesEvent({required this.act});

  @override
  List<Object> get props => [];
}class GetActivitiesOfMonthEvent extends AcivityFEvent {
  final activity act;

 const  GetActivitiesOfMonthEvent({required this.act});

  @override
  List<Object> get props => [act];
}
class GetActivitiesByid extends AcivityFEvent {
final activityParams params;
  const GetActivitiesByid({required this.params});

  @override
  List<Object> get props => [params];
}

class SearchTextChanged extends AcivityFEvent {
  final String searchText;

  const SearchTextChanged(this.searchText);

  @override
  List<Object> get props => [searchText];
}
