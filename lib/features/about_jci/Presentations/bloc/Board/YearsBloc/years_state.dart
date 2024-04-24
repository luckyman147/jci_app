part of 'years_bloc.dart';
enum yearsStates{Initial,Loading,Loaded,Error,Changed,Roles,ErrorRole,ErrorChanged,ChangedPosition}
 class YearsState extends Equatable {
   final List<String> years;
   final List<BoardRole> roles;
   final Map<String,dynamic> newrole;
   final bool hasReachedMax;
   final String year;
   final String cloneyear;

final Map<String,dynamic> CurrentPriority;

    final String message;
    final yearsStates state;


  const YearsState({this.state=yearsStates.Initial,this.years=const [],this.message='',this.hasReachedMax=false,this.year='',this.cloneyear='',

    this.CurrentPriority=const {},

    this.roles=const [],this.newrole=const {}});
  YearsState copyWith({yearsStates? state,List<String>? years,String? message,bool? hasReachedMax,String? year,String? cloneyear,List<BoardRole>? roles,Map<String,dynamic>? newrole,Map<String,dynamic>? Prioritys,Map<String,dynamic>? CurrentPriority}) {
    return YearsState(state: state??this.state,years: years??this.years,message: message??this.message,hasReachedMax: hasReachedMax??this.hasReachedMax,year: year??this.year,
    CurrentPriority: CurrentPriority??this.CurrentPriority,
    roles: roles??this.roles,cloneyear: cloneyear??this.cloneyear,newrole: newrole??this.newrole);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [years,message,hasReachedMax,state,year,cloneyear,roles,newrole,CurrentPriority];
}

class YearsInitial extends YearsState {
  @override
  List<Object> get props => [];
}
