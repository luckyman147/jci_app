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
  final activity act;

final String id;
  const GetActivitiesByid({required this.act,required this.id});

  @override
  List<Object> get props => [act];
}

class SearchTextChanged extends AcivityFEvent {
  final String searchText;

  const SearchTextChanged(this.searchText);

  @override
  List<Object> get props => [searchText];
}