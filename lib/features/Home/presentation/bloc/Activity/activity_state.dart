part of 'activity_cubit.dart';


enum activity { Events, Meetings, Trainings,All }
enum StateChange { Initial,Changed }

class ActivityState extends Equatable {
  final activity selectedActivity;
  final activity selectedSearchActivity;
  final StateChange stateChange;
final int index;
final bool isSearching ;
  ActivityState(this.selectedActivity,{this.index=0,this.isSearching=false,this.selectedSearchActivity=activity.All,this.stateChange=StateChange.Initial});
  ActivityState copyWith({activity? selectedActivity,int? index,bool? isSearching,activity? selectedSearchActivity,StateChange? stateChange}) {
    return ActivityState(selectedActivity ?? this.selectedActivity,index: index??this.index,isSearching: isSearching??this.isSearching,selectedSearchActivity: selectedSearchActivity??this.selectedSearchActivity,stateChange: stateChange??this.stateChange);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [selectedActivity,index,isSearching,selectedSearchActivity,stateChange];
}

